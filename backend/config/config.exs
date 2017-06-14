# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :aptamer,
  ecto_repos: [Aptamer.Repo],
  start_jobs: true

# Configures the endpoint
config :aptamer, Aptamer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IccgQqMtrQrDjvRIlwgs/3ni1qizFseXblYBn2sMEePo0SR7WQadi0+xYWZS7isa",
  render_errors: [view: Aptamer.ErrorView, accepts: ~w(html json json-api)],
  pubsub: [name: Aptamer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  binary_id: true

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Aptamer.User,
  repo: Aptamer.Repo,
  module: Aptamer,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :invitable, :registerable]

config :coherence, Aptamer.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
#
config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
    "application/vnd.api+json" => ["json-api"]
}

config :ja_serializer,
  pluralize_types: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

