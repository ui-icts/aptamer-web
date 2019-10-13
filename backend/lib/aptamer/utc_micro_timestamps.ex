defmodule Aptamer.UtcMicroTimestamps do
  defmacro __using__([]) do
    quote do
      @timestamp_opts [type: :utc_datetime_usec]
    end
  end
end
