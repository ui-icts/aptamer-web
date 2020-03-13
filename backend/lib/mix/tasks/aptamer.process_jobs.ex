defmodule Mix.Tasks.Aptamer.ProcessJobs do
  use Mix.Task

  @shortdoc "Starts the job processor"
  def run(_) do
    IO.puts("Running job procesor")
    Application.ensure_all_started(:aptamer)
    Aptamer.Jobs.Processor.execute_ready_jobs()
  end
end
