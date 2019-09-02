defmodule AptamerWeb.JobHelpers do
  use Phoenix.HTML

  def is_running?(job) do
    case job.status do
      "finished" -> false
      "error" -> false
      _ -> true
    end
  end

  def job_description(job, index) do
    "Job #{job_number(index)} #{job.status}."
  end

  def job_number(index) do
    "##{index+1}"
  end
end
