defmodule Aptamer.JobControl do
  # use GenServer
  
  alias Aptamer.Repo

  defmodule Job do
    defstruct job_id: "UNSET", owner_id: nil, file_id: nil, program: "date", args: [], output: []
  end

  defimpl Collectable, for: Job do
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

      Process.sleep(3000)
      cs = Aptamer.Job.changeset(job, %{status: "running"})
      {:ok, job} = Repo.update cs
      json = JaSerializer.format( Aptamer.JobView, job )
      Aptamer.Endpoint.broadcast("jobs:status", "status_change", json)

      args = ["-u", "long_run.py", job.id, "100","2"]
      System.cmd("python", args, into: %Job{job_id: job.id})
      cs = Aptamer.Job.changeset(job, %{status: "finished"})
      {:ok, job} = Repo.update cs
      json = JaSerializer.format( Aptamer.JobView, job )
      Aptamer.Endpoint.broadcast("jobs:status", "status_change", json)

    end)
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
