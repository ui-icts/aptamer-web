defmodule Aptamer.JobsChannel do
  use Phoenix.Channel

  def join("jobs:status", _message, socket) do
    {:ok, socket}
  end

end
