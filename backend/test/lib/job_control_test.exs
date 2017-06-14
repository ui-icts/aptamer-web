defmodule Aptamer.JobControlTest do
  use ExUnit.Case, async: false

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

  # test "Able to list registered jobs", %{process: jc} do
  #   sample = %JD{owner_id: 1, file_id: 2}
  #   job =  JobControl.submit_job(jc, sample)
  #
  # end
end
