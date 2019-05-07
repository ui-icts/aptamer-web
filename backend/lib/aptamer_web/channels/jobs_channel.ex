defmodule AptamerWeb.JobsChannel do
  use Phoenix.Channel
  alias Porcelain.Process, as: Proc

  ###### Client Calls ###########
  def broadcast_job_status(job) do
    json = JaSerializer.format(AptamerWeb.JobView, job)
    # I think usually these channel objects aren't meant
    # to have a client interface that is called from other
    # parts of the code ... but this is the place we wanted
    # to look for this behaviour so YOLO
    # The way you initiate a broadcast from somewhere else
    # was to use the `Endpoint` because at this point I don't
    # have a socket so can't call the 'broadcast!' function
    AptamerWeb.Endpoint.broadcast("jobs:status", "status_change", json)
  end

  def broadcast_job_output(job, output) do
    AptamerWeb.Endpoint.broadcast("jobs:" <> job.job_id, "job_output", %{
      job_id: job.job_id,
      lines: [output]
    })
  end

  def broadcast_file_added(file) do
    json = JaSerializer.format(AptamerWeb.FileView, file)
    AptamerWeb.Endpoint.broadcast("jobs:status", "file_added", json)
  end

  def broadcast_worker_entered(node_name) do
    AptamerWeb.Endpoint.broadcast("jobs:status","worker_entered", %{node_name: node_name})
  end

  def broadcast_worker_left(node_name) do
    AptamerWeb.Endpoint.broadcast("jobs:status","worker_left", %{node_name: node_name})
  end

  def broadcast_worker_reset(worker_list) do
    workers = Enum.map(worker_list, fn x -> %{node_name: x} end)
    AptamerWeb.Endpoint.broadcast("jobs:status","worker_reset", workers)
  end
  ###############################

  def join("jobs:status", _message, socket) do
    {:ok, "Welcome to the jobs status channel", socket}
  end

  def join("jobs:" <> job_id, _message, socket) do
    {:ok, "Now receving messages related to #{job_id}", socket}
  end

  def handle_in("start_job", %{"body" => body}, socket) do
    broadcast!(socket, "start_job", %{body: "Job received"})

    Aptamer.JobControl.start_job(body)
    # proc = %Proc{out: outstream} = Porcelain.spawn("python", args, opts)
    # Enum.take(outstream, 1) |> Enum.each( fn(x) -> IO.puts x end)
    # state = %{proc: p}
    # Poop.loop(state)
    # Enum.into(outstream, IO.stream(:stdio, 2))
    {:reply, {:ok, %{body: body}}, socket}
  end
end
