defmodule Aptamer.Jobs.JobStatus do
  alias Aptamer.Jobs.{File, Job}

  def topic(%Job{} = job) do
    topic(job.file_id)
  end

  def topic(%File{} = file) do
    topic(file.id)
  end

  def topic(file_id) do
    "file:#{file_id}:job_status"
  end

  def broadcast(%Job{} = job) do
    Phoenix.PubSub.broadcast(
      AptamerWeb.PubSub,
      topic(job.file_id),
      {:status_change, job.id, job.status}
    )
  end
end
