defmodule Aptamer.Jobs.Processor do
  alias Aptamer.Repo
  alias Aptamer.Jobs.{UserFiles, File, Job, Result, JobStatus, PythonScriptJob}

  def execute_ready_jobs() do
    Aptamer.Jobs.ready_batch() |> execute_jobs()
  end

  defp execute_jobs([job | rest]) do
    execute(job)
    execute_jobs(rest)
  end

  defp execute_jobs([]) do
    :ok
  end

  def execute_next_job() do
    job = Aptamer.Jobs.next_ready()

    if job do
      execute(job)
    end
  end

  def execute(job) do
    job = Aptamer.Jobs.load_associations(job)

    script_job =
      job
      |> File.build_script_args()
      |> PythonScriptJob.create()

    {job, script_job}
    |> set_job_status(:starting)
    |> execute_step(:prepare_files)
    |> set_job_status(:running)
    |> execute_step(:run_script)
    |> set_job_status(:processing_results)
    |> execute_step(:save_generated_files)
    |> execute_step(:zip_outputs)
    |> execute_step(:cleanup)
    |> save_results()
    |> set_job_status(:finished)
  end

  def set_job_status({job, script}, status) do
    cs = Job.changeset(job, %{status: to_string(status)})
    {:ok, job} = Repo.update(cs)
    JobStatus.broadcast(job)
    {job, script}
  end

  def execute_step({job, script}, step) do
    script = apply(PythonScriptJob, step, [script])
    {job, script}
  end

  def save_results({job, script}) do
    if script.archive do
      {:ok, _result} =
        %Result{job_id: job.id, archive: script.archive}
        |> Repo.insert()
    end

    if script.generated_file != nil do
      file = %{script.generated_file | file_owner_id: job.file.owner_id}
      {:ok, file} = Repo.insert(file)
      UserFiles.broadcast_file_generated(file)
    end

    {job, script}
  end
end
