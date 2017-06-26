defmodule Aptamer.JobControl do
  # use GenServer

  alias Aptamer.{Repo, PredictStructureOptions, CreateGraphOptions}

  defmodule RunningJob do
    defstruct job_id: "UNSET", output: []

    defimpl Collectable do
      import Aptamer.Endpoint, only: [broadcast: 3]

      def into(job) do
        {job.output, fn
          list, {:cont, output} ->
            broadcast("jobs:" <> job.job_id, "job_output", %{job_id: job.job_id, lines: [output]})
            [output|list]

          list, :done -> %{job | output: Enum.reverse(list)}
          _, :halt -> :ok
        end}
      end

    end

  end

  def start_job(%Aptamer.Job{} = job) do
    Task.start(fn ->

      {script_name, program_args} = case job.file.file_type do
        "structure" -> {"create_graph.py", CreateGraphOptions.args(job.create_graph_options)}
        "fasta" -> {"predict_structures.py", PredictStructureOptions.args(job.predict_structure_options)}
      end

      listener = spawn(Aptamer.JobControl,:on_broadcast,[job])

      script_job = Aptamer.Jobs.PythonScriptJob.create(script_name, program_args, job.file.data)
      script_job = %{script_job | 
          current_user_id: job.file.owner_id,
          output_collector: %Aptamer.JobControl.RunningJob{job_id: job.id,
          output: ["Initializing job..."]},
          listener: listener, job_id: job.id,
          input_file_name: job.file.file_name}

      wh_result = Wormhole.capture(Aptamer.Jobs.PythonScriptJob,:run,[script_job], timeout_ms: 3_600_000) 
      task_finished(wh_result, job.id)
    end)

  end

  def on_broadcast(job) do
    receive do
      {:broadcast, {:begin, step_name}} ->
        cs = Aptamer.Job.changeset(job, %{status: to_string(step_name)})
        {:ok, job} = Repo.update cs
        broadcast_status(job)
        on_broadcast(job)
      {:broadcast, {:finish, :cleanup}} ->
        #Do nothing we're done listening
        :ok
      _ -> on_broadcast(job)
    end

  end
  def task_finished({:ok, {:ok, script_job}}, job_id) do
    job = Repo.get!(Aptamer.Job,job_id)
    cs = Aptamer.Job.changeset(job, %{status: "finished", output: script_job.output})
    {:ok, job} = Repo.update cs
    broadcast_status(job)
  end

  def task_finished({:error, error}, job_id) do
    IO.puts "-----------------------------------------"
    IO.inspect error

    job = Repo.get!(Aptamer.Job,job_id)
    cs = Aptamer.Job.changeset(job, %{status: "error"})
    {:ok, job} = Repo.update cs
    broadcast_status(job)
  end

  defp set_status(job, status, output \\ nil) do

    output = case output do
      %RunningJob{output: x} -> Enum.join(x, "\n")
      nil -> nil
    end
    cs = Aptamer.Job.changeset(job, %{status: status, output: output})

    {:ok, job} = Repo.update cs
    job
  end

  defp broadcast_status(job) do
    json = JaSerializer.format( Aptamer.JobView, job )
    Aptamer.Endpoint.broadcast("jobs:status", "status_change", json)
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
