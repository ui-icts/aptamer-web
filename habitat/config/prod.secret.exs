use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :aptamer, Aptamer.Endpoint,
  secret_key_base: "01BgHAmJr7VcdaWMw1XqbLJNAl9tqzEEvHxYRjjvc8TticZ5p6yOd/HgrzBVb8T2"

config :aptamer, Aptamer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: {{cfg.database_name}}
{{#if bind.has_database}}
  {{~#eachAlive bind.database.members as |member|}}
  host: {{member.sys.ip}}
  port: {{member.cfg.port}}
  {{~/eachAlive}}
{{else}}
  host: {{cfg.database_host}}
  port: {{cfg.database_port}}
{{/if}}
  database: "aptamer_prod",
  pool_size: 20
