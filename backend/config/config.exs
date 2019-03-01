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
config :aptamer, AptamerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IccgQqMtrQrDjvRIlwgs/3ni1qizFseXblYBn2sMEePo0SR7WQadi0+xYWZS7isa",
  render_errors: [view: AptamerWeb.ErrorView, accepts: ~w(html json json-api)],
  pubsub: [name: AptamerWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :aptamer, Aptamer.Mailer,
  adapter: Bamboo.SMTPAdapter,
  # SMTP server here
  server: "smtp.office365.com",
  hostname: "uiowa.edu",
  username: "ICTS-aptamer-mailer@uiowa.edu",
  password: {:system, "SMTP_PASSWORD"},
  port: 587,
  # can be `:always` or `:never`
  tls: :always,
  # or {":system", ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  allowed_tls_versions: [:"tlsv1.2"],
  # can be `true`
  ssl: false,
  retries: 1

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators, binary_id: true

config :comeonin, Ecto.Password, Comeonin.Bcrypt
config :comeonin, :bcrypt_log_rounds, 14
config :phoenix, :json_library, Jason

config :phoenix, :format_encoders, "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :ja_serializer,
  pluralize_types: true

config :tzdata, :autoupdate, :disabled

config :aptamer, Aptamer.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: Aptamer,
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: false,
  secret_key: "I2L/NVCn3tkCLORNkTD6yjySm0SqIMmDv508WEIG/7uxccze8tYsWqbGA4seN9s"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
