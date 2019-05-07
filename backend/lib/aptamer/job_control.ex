defmodule Aptamer.JobControl do
  use GenServer

  alias Aptamer.Repo
  alias Aptamer.Jobs
  alias Aptamer.Jobs.{PredictStructureOptions, CreateGraphOptions}

  @server_name __MODULE__

  def start_job(%Aptamer.Jobs.Job{} = job, worker_node) do
    {:ok, task_pid} = Task.Supervisor.start_child({Aptamer.JobControl.TaskSupervisor, worker_node}, fn ->

      job = Jobs.load_associations(job)

      {script_name, program_args} =
        case job.file.file_type do
          "structure" ->
            {"create_graph.py", CreateGraphOptions.args(job.create_graph_options)}

          "fasta" ->
            {"predict_structures.py", PredictStructureOptions.args(job.predict_structure_options)}
        end

      listener = spawn(Aptamer.JobControl, :on_broadcast, [job])

      script_job = Aptamer.Jobs.PythonScriptJob.create(script_name, program_args, job.file.data)

      script_job = %{
        script_job
        | current_user_id: job.file.owner_id,
          output_collector: %Aptamer.JobControl.RunningJob{
            job_id: job.id,
            output: ["Initializing job..."]
          },
          listener: listener,
          job_id: job.id,
          input_file_name: job.file.file_name
      }

      wh_result =
        Wormhole.capture(Aptamer.Jobs.PythonScriptJob, :run, [script_job], timeout_ms: 3_600_000)

      task_finished(wh_result, job.id)
    end)
  end

  def on_broadcast(job) do
    receive do
      {:broadcast, {:begin, step_name}} ->
        job = update_job_status(job,step_name)
        broadcast_status(job)
        on_broadcast(job)

      {:broadcast, {:finish, :cleanup}} ->
        # Do nothing we're done listening
        :ok

      _ ->
        on_broadcast(job)
    end
  end

  def task_finished({:ok, {:ok, script_job}}, job_id) do
    # Update job to mark as finished
    job = Repo.get!(Aptamer.Jobs.Job, job_id)
    cs = Aptamer.Jobs.Job.changeset(job, %{status: "finished", output: script_job.output})
    {:ok, job} = Repo.update(cs)
    AptamerWeb.Email.send_job_complete(job)
    broadcast_status(job)

    # send added file if present
    case script_job do
      %{generated_file: file} when not is_nil(file) ->
        AptamerWeb.JobsChannel.broadcast_file_added(file)

      _ ->
        :ok
    end
  end

  def task_finished({:error, error}, job_id) do
    IO.puts("-----------------------------------------")
    IO.inspect(error)

    job = Repo.get!(Aptamer.Jobs.Job, job_id)
    cs = Aptamer.Jobs.Job.changeset(job, %{status: "error"})
    {:ok, job} = Repo.update(cs)
    AptamerWeb.Email.send_job_complete(job)
    broadcast_status(job)
  end

  defp set_status(job, status, output \\ nil) do
    output =
      case output do
        %Aptamer.JobControl.RunningJob{output: x} -> Enum.join(x, "\n")
        nil -> nil
      end

    cs = Aptamer.Jobs.Job.changeset(job, %{status: status, output: output})

    {:ok, job} = Repo.update(cs)
    job
  end

  defp broadcast_status(job) do
    AptamerWeb.JobsChannel.broadcast_job_status(job)
  end

  defp update_job_status(job, step_name) do
    cs = Aptamer.Jobs.Job.changeset(job, %{status: to_string(step_name)})
    {:ok, job} = Repo.update(cs)
    job
  end

  ##
  # Client
  #
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: @server_name)
  end

  def init(opts) do
    Process.send_after(self(), :check_nodes, 5000)
    {:ok, opts}
  end
  def submit_job(job) do
    GenServer.cast @server_name, {:submit, job}
  end

  def register_worker(on_node, at_pid) do
    GenServer.cast @server_name, {:register_worker, on_node, at_pid}
  end

  def workers() do
    GenServer.call @server_name, {:workers}
  end

  def clear_workers() do
    GenServer.cast @server_name, {:clear_workers}
  end

  def check_for_worker() do
    GenServer.cast @server_name, {:check_for_worker}
  end
  ##
  # Server
  #
  def handle_cast({:submit, job}, state) do
    Aptamer.JobControl.start_job(job, node())
    {:noreply, state}
  end

  def handle_cast({:register_worker, on_node, at_pid}, state) do
    AptamerWeb.JobsChannel.broadcast_worker_entered(on_node)
    Aptamer.JobControl.check_for_worker()
    {:noreply, [on_node | state]}
  end

  def handle_cast({:clear_workers}, state) do
    Enum.each(state, fn w ->
      clean_worker(w)
    end)
    AptamerWeb.JobsChannel.broadcast_worker_reset([])
    {:noreply, []}
  end

  defp clean_worker(w) do
    case w do
      {node,task} ->
        Task.Supervisor.terminate_child(Aptamer.JobControl.TaskSupervisor, task)
        Node.disconnect(node)
        AptamerWeb.JobsChannel.broadcast_worker_left(node)
      node ->
        Node.disconnect(node)
        AptamerWeb.JobsChannel.broadcast_worker_left(node)
    end
  end

  def handle_cast({:check_for_worker}, state) do

    idle_nodes = Enum.filter(state, fn x ->
      case x do
        {_node,_task} -> false
        node -> true
      end
    end) |> MapSet.new

    connected_nodes = MapSet.new(Node.list())
    available_nodes = MapSet.intersection(idle_nodes,connected_nodes)

    available_node = MapSet.to_list(available_nodes) |> List.first

    if available_node do
      job = Aptamer.Jobs.next_ready()
      if job do
        {:ok, task_pid} = Aptamer.JobControl.start_job(job, available_node)
        state = List.delete(state, available_node)
        state = [{available_node, task_pid} | state]
      end
    end
    {:noreply, state}
  end

  def handle_call({:workers}, from, state) do
    {:reply, state, state}
  end

  def handle_info(:check_nodes, state) do

    connected_nodes = Node.list()
    {keep,remove} = Enum.split_with(state, fn w ->
      case w do
        {n,_} -> n in connected_nodes
        n -> n in connected_nodes
      end
    end)

    Enum.each(remove, fn w ->
      clean_worker(w)
    end)

    Process.send_after(self(), :check_nodes, 5000)

    {:noreply, keep}
  end
  # def handle_call({:submit, job}, from, job_list) do
  #   {:reply, :ok, []}
  # end
end
