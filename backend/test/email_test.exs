defmodule Aptamer.EmailTest do
  use ExUnit.Case
  import Aptamer.Factory
  alias Aptamer.Email

  doctest Email

  test "doesn't send email for nil job" do
    error = "job cannot be nil. Not sending job completion email..."

    assert {:error, error} == Email.send_job_complete(nil)
  end

  # reading that mocking is bad...hmm
  test "constructs valid email" do
    user = build(:user, email: "user@example.com") |> insert
    file = build(:file, file_name: "Kenobi", owner: user, file_tpye: "struct.fa", file_id: 10) |> as_structure |> insert
    ps_opts = build(:predict_structure_options) |> insert
    job = insert(:job, file: file, predict_structure_options: ps_opts, create_graph_options: nil)

    expected =
      %Bamboo.Email{assigns: %{}, bcc: [], cc: [], from: {nil, "aptamer@uiowa.edu"}, headers: %{},
      html_body: "Your job predict structures for file Kenobi has completed
      <strong>successfully</strong>!<a href=\"http://localhost:4000/results/10\">
      Download the results here!</a>", private: %{}, subject: "Job complete",
      text_body: nil, to: [nil: "user@example.com"]}

    assert expected == Email.send_job_complete(job)
  end
end
