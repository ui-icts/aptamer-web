use Mix.Config

config :aptamer,
  start_jobs: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :aptamer, Aptamer.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :aptamer, Aptamer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "aptamer_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, :bcrypt_log_rounds, 4