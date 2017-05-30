defmodule Aptamer.JobsChannel do
  use Phoenix.Channel
  alias Porcelain.Process, as: Proc

  def join("jobs:status", _message, socket) do
    {:ok,"Welcome to the jobs status channel", socket}
  end

  def join("jobs:" <> job_id, socket) do
    {:ok,"No receving messages related to #{job_id}", socket}
  end

  def handle_in("start_job", %{"body" => body}, socket) do
    broadcast! socket, "start_job", %{body: "Job received"}

    Aptamer.JobControl.start_job(body)
    # proc = %Proc{out: outstream} = Porcelain.spawn("python", args, opts)
    # Enum.take(outstream, 1) |> Enum.each( fn(x) -> IO.puts x end)
    # state = %{proc: p}
    # Poop.loop(state)
    # Enum.into(outstream, IO.stream(:stdio, 2))
    {:reply,{:ok, %{body: body}}, socket}
  end

  def handle_info({f, :data, :out, line}, socket) do
    broadcast! socket, "job_output", %{line: line}
    {:noreply, socket}
  end

  def handle_info({f, :data, :err, line}, socket) do
    broadcast! socket, "job_output", %{line: "ERROR:" <> line}
    {:noreply, socket}
  end

  def handle_info({f,:result,%Porcelain.Result{} = x}, socket) do
    IO.puts " Handle result"
    IO.inspect x
    broadcast! socket, "job_output", %{line: "Job finish"}
    {:noreply, socket}
  end
end
