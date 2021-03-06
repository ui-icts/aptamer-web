defmodule Aptamer.JobControl do
  # use GenServer

  alias Aptamer.Repo
  alias Aptamer.Jobs.{PredictStructureOptions, CreateGraphOptions}

  defmodule RunningJob do
    defstruct job_id: "UNSET", output: []

    defimpl Collectable do
      def into(job) do
        {job.output,
         fn
           list, {:cont, output} ->
             AptamerWeb.JobsChannel.broadcast_job_output(job, output)

             [output | list]

           list, :done ->
             %{job | output: Enum.reverse(list)}

           _, :halt ->
             :ok
         end}
      end
    end
  end

  def start_job(%Aptamer.Jobs.Job{} = job) do
    Task.start(fn ->
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
        cs = Aptamer.Jobs.Job.changeset(job, %{status: to_string(step_name)})
        {:ok, job} = Repo.update(cs)
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
        %RunningJob{output: x} -> Enum.join(x, "\n")
        nil -> nil
      end

    cs = Aptamer.Jobs.Job.changeset(job, %{status: status, output: output})

    {:ok, job} = Repo.update(cs)
    job
  end

  defp broadcast_status(job) do
    AptamerWeb.JobsChannel.broadcast_job_status(job)
  end

  ##
  # Client
  #

  # def start_link(opts \\ []) do
  #   GenServer.start_link(__MODULE__,:ok,opts)
  # end
  #
  # def submit_job(server, job) do
  #   GenServer.call(server, {:submit, job})
  # end

  ##
  # Server
  #

  # def init(:ok) do
  #   {:ok, []}
  # end
  #
  # def handle_call({:submit, job}, from, job_list) do
  #   {:reply, :ok, []}
  # end
end
