# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :aptamer,
  ecto_repos: [Aptamer.Repo]

# Configures the endpoint
config :aptamer, Aptamer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IccgQqMtrQrDjvRIlwgs/3ni1qizFseXblYBn2sMEePo0SR7WQadi0+xYWZS7isa",
  render_errors: [view: Aptamer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Aptamer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
