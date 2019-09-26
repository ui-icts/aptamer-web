defmodule Aptamer.Jobs.Processor do
  alias Aptamer.{Repo,JobControl}
  alias Aptamer.Jobs.{File,Job,PythonScriptJob}

  def do_next_job() do
    job = Aptamer.Jobs.next_ready() |> Aptamer.Jobs.load_associations()

    if job do
      script_args = File.build_script_args(job.file, job)
      script_job = PythonScriptJob.create(script_args)
      {:ok, script_job} = PythonScriptJob.run(script_job)
      JobControl.task_finished({:ok, {:ok, script_job}}, job.id)
    end
  end
end
