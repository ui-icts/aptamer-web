defmodule AptamerWeb.Email do
  import Bamboo.Email
  require Logger
  alias Aptamer.{Repo, Mailer}
  alias Aptamer.Jobs.Job
  alias AptamerWeb.Endpoint

  def send_job_complete(job) when is_nil(job) do
    error = "job cannot be nil. Not sending job completion email..."

    Logger.error(error)

    {:error, error}
  end

  def send_job_complete(job) do
    IO.puts("Sending completion email..")

    aptamer_job_email(job)
    |> Mailer.deliver_later()
  end

  def aptamer_job_email(job) do
    {:ok, user} = job_author(job)

    new_email
    |> to(user.email)
    |> from({"Aptamer Notifier", "ICTS-aptamer-mailer@uiowa.edu"})
    |> subject("Job complete")
    |> html_body(
      "<i>This email was automatically sent to notify you that a job was completed. Please do not reply to this address</i><hr><br>"
    )
    |> html_body(job_email_text(job))
  end

  defp job_email_text(job) do
    success_message =
      "Your job " <> Job.description(job) <> " has completed <strong>successfully</strong>! "

    home_url = html_link("View Job", Endpoint.url())
    # can't do this in the guard itself

    case job.status do
      finished ->
        download_url = Endpoint.url() <> "/results/" <> job.id
        success_message <> html_link("Download the results here!", download_url)

      error ->
        "Your job " <>
          Job.description(job) <> " has errored out and <strong>failed</strong>. " <> home_url

      _ ->
        raise "unhandled job status passed. job.status: " <> job.status
    end
  end

  defp html_link(text, url) do
    ~s(<a href="#{url}">#{text}</a>)
  end

  defp job_author(job) do
    job =
      job
      |> Repo.preload(file: :owner)

    {:ok, job.file.owner}
  end
end
