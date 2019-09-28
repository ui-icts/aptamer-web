defmodule Aptamer.Repo do
  use Ecto.Repo, otp_app: :aptamer, adapter: Ecto.Adapters.Postgres

  def init(_call_context, opts) do
    {:ok, Aptamer.EnvConfig.override_repo_config(System.get_env(), opts)}
  end
end
