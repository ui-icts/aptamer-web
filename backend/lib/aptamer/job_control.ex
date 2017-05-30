defmodule Aptamer.JobControl do
  # use GenServer

  defmodule Job do
    defstruct owner_id: nil, file_id: nil, program: "date", args: [], output: []
  end

  defimpl Collectable, for: Job do
    def into(job) do
      {[], fn
        list, {:cont, output} -> 
          Aptamer.Endpoint.broadcast("jobs:status", "job_output", %{line: output})
          [output|list]
        list, :done -> %{job | output: Enum.reverse(list)}
        _, :halt -> :ok
      end}
    end
  end

  def start_job(body) do
    Task.start(fn ->
      args = ["-u", "long_run.py", body, "100","2"]
      System.cmd("python", args, into: %Job{})
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
