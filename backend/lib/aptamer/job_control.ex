defmodule Aptamer.JobControl do
  # use GenServer
  
  alias Aptamer.Repo

  defmodule RunningJob do
    defstruct job_id: "UNSET", owner_id: nil, file_id: nil, program: "date", args: [], output: []
  end

  defimpl Collectable, for: RunningJob do
    def into(job) do
      {[], fn
        list, {:cont, output} -> 
          Aptamer.Endpoint.broadcast("jobs:" <> job.job_id, "job_output", %{job_id: job.job_id, lines: [output]})
          [output|list]
        list, :done -> %{job | output: Enum.reverse(list)}
        _, :halt -> :ok
      end}
    end
  end


  def start_job(%Aptamer.Job{} = job) do
    Task.start(fn ->

      job = set_status(job, "preparing")
      broadcast_status(job)


      job = Repo.preload(job, :create_graph_options)
      job = Repo.preload(job, :file)

      {:ok, temp_path} = Temp.mkdir job.id
      input_file = Path.join(temp_path, "input_struct.fa")
      File.write input_file, job.file.data

      options = job.create_graph_options

      args = ["-u", "/Users/cortman/aptamer/python-scripts/create_graph.py",
              input_file,
              "-t", options.edge_type,
              "-e", to_string(options.max_edit_distance),
              "-d", to_string(options.max_tree_distance),
      ]

      if options.seed do
        args = args ++ ["--seed"]
      end

      try do

        job = set_status(job, "running")
        broadcast_status(job)

        {output, exit_status} = System.cmd(
          "/Users/cortman/.virtualenvs/aptamer-runtime/bin/python",
          args,
          cd: temp_path,
          into: %RunningJob{job_id: job.id}
        )

        job = set_status(job, "finished", output)
        broadcast_status(job)

      rescue

        e in ArgumentError ->
          IO.inspect(e)

          Aptamer.Endpoint.broadcast("jobs:" <> job.id, "job_output", %{job_id: job.id, lines: [ArgumentError.message(e)]})
          set_status(job, "failed")
          broadcast_status(job)
      end
    end)
  end

  defp set_status(job, status, output \\ nil) do
    params = %{status: status}

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
