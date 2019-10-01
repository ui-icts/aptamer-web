defmodule AptamerWeb.EmailTest do
  use Aptamer.DataCase
  import Aptamer.Factory
  alias AptamerWeb.Email

  doctest Email

  test "doesn't send email for nil job" do
    error = "job cannot be nil. Not sending job completion email..."

    assert {:error, error} == Email.send_job_complete(nil)
  end

  # reading that mocking is bad...hmm
  test "constructs valid email" do
    user = build(:user, email: "user@example.com") |> insert

    file =
      build(:file, file_name: "Kenobi", owner: user)
      |> as_structure
      |> insert

    ps_opts = build(:predict_structure_options) |> insert

    job =
      insert(:job,
        file: file,
        predict_structure_options: ps_opts,
        create_graph_options: nil,
        status: "finished"
      )

    assert %Bamboo.Email{
             assigns: %{},
             bcc: [],
             cc: [],
             from: {"Aptamer Notifier", "ICTS-aptamer-mailer@uiowa.edu"},
             headers: %{},
             html_body: _,
             private: %{},
             subject: "Job complete",
             text_body: nil,
             to: [nil: "user@example.com"]
           } = Email.send_job_complete(job)
  end
end
