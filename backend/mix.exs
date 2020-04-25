defmodule Aptamer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :aptamer,
      version: File.read!("../version.txt") |> String.trim(),
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      releases: releases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Aptamer.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.1"},
      {:plug, "~> 1.7"},
      {:timex, "~> 3.0"},
      {:ex_machina, "~> 2.4.0", only: :test},
      {:proper_case, "~> 1.3.0"},
      {:mix_test_watch, "~> 1.0.2", only: :dev, runtime: false},
      {:fs, "~> 6.1.1", override: true},
      {:temp, "~> 0.4"},
      {:comeonin, "~> 5.3"},
      {:bcrypt_elixir, "~> 2.2.0"},
      {:guardian, "~> 2.0"},
      {:bamboo, "~> 1.4"},
      {:bamboo_smtp, "~> 2.1.0"},
      {:phoenix_live_view, "~> 0.12.0"},
      {:floki, ">=0.0.0", only: :test},
      {:libcluster, "~> 3.1"},
      {:number, "~> 1.0.0"}
    ]
  end

  def releases() do
    [
      aptamer: []
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
