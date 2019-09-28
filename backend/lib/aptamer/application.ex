defmodule Aptamer.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    topologies = [
      dynamic: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      Aptamer.Repo,
      # Start the endpoint when the application starts
      AptamerWeb.Endpoint,
      {Cluster.Supervisor, [topologies, [name: Aptamer.ClusterSupervisor]]}
      # Start your own worker by calling: Aptamer.Worker.start_link(arg1, arg2, arg3)
      # worker(Aptamer.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aptamer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AptamerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
