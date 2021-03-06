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
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:ecto_sql, "~> 3.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:jason, "~> 1.0"},
      {:timex, "~> 3.0"},
      {:jsonapi, git: "https://github.com/jeregrine/jsonapi"},
      {:ex_machina, "~> 2.2.2", only: :test},
      {:proper_case, "~> 1.2.0"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:fs, "~> 0.9", override: true},
      {:ja_serializer, git: "https://github.com/vt-elixir/ja_serializer"},
      {:porcelain, "~> 2.0"},
      {:temp, "~> 0.4"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.1"},
      {:guardian, "~> 1.0"},
      {:wormhole, git: "https://github.com/renderedtext/wormhole"},
      {:bamboo, "~> 0.8"},
      {:bamboo_smtp, "~> 1.4.0"}
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
