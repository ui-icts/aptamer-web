defmodule Aptamer.JobsChannel do
  use Phoenix.Channel

  def join("jobs:status", _message, socket) do
    {:ok,"Welcome to the jobs status channel", socket}
  end

  def handle_in("start_job", %{"body" => body}, socket) do
    broadcast! socket, "start_job", %{body: body}
    {:reply,{:ok, %{body: body}}, socket}
  end
end
