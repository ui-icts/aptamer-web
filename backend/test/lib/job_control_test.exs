defmodule Aptamer.JobControlTest do
  use ExUnit.Case, async: true

  import Aptamer.Factory
  # alias Aptamer.JobControl.Job, as: :JD
  # setup do
  #   {:ok, jc} = JobControl.start_link()
  #
  #   on_exit fn ->
  #     GenServer.stop(Aptamer.JobControl)
  #   end
  #
  #   {:ok, process: jc}
  # end


  @tag :focus
  test "Runs a job and delivers results on " do
    file = build(:file) |> as_structure
    job = insert(:job, file: file, create_graph_options: build(:create_graph_options))

    {:ok, pid} = Aptamer.JobControl.start_job(job)
  end
end
