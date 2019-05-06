defmodule Aptamer.JobControl.RunningJob do
  defstruct job_id: "UNSET", output: []

  defimpl Collectable do
    def into(job) do
      {job.output,
        fn
          list, {:cont, output} ->
            AptamerWeb.JobsChannel.broadcast_job_output(job, output)

            [output | list]

          list, :done ->
            %{job | output: Enum.reverse(list)}

          _, :halt ->
            :ok
        end}
    end
  end
end
