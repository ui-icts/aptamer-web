defmodule Aptamer.JobControl.RemoteWorker do

  def start(web_node) do
    GenServer.cast({Elixir.Aptamer.JobControl, web_node}, {:register_worker, node(), self()})
  end
end
