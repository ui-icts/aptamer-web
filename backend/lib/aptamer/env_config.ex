defmodule Aptamer.EnvConfig do

  def override_endpoint_config(env_vars, endpoint_opts) do
    endpoint_opts = apply_config(:port, env_vars["PORT"], endpoint_opts)
    endpoint_opts = apply_config(:web_host, env_vars["WEB_HOST"], endpoint_opts)
    endpoint_opts = apply_config(:secret_key_base, env_vars["SECRET_KEY_BASE"], endpoint_opts)

    endpoint_opts
  end

  def override_repo_config(env_vars, repo_opts) do
    repo_opts = apply_config(:hostname, env_vars["DATABASE_HOST"], repo_opts)
    repo_opts = apply_config(:username, env_vars["DATABASE_USER"], repo_opts)
    repo_opts = apply_config(:password, env_vars["DATABASE_PASSWORD"], repo_opts)
    repo_opts = apply_config(:database, env_vars["DATABASE_NAME"], repo_opts)

    repo_opts
  end

  def override_smtp_config(env_vars, smtp_opts) do
    smtp_opts = apply_config(:password, env_vars["SMTP_PASSWORD"], smtp_opts)
    smtp_opts
  end

  def apply_config(any, nil, endpoint_opts), do: endpoint_opts
  def apply_config(:port, value, endpoint_opts) when is_binary(value) do

    port = String.to_integer(value)

    endpoint_opts
    |> Keyword.put_new(:http,[])
    |> put_in([:http,:port], port)
  end

  def apply_config(:web_host, value, endpoint_opts) when is_binary(value) do
    endpoint_opts
    |> Keyword.put_new(:url, [])
    |> put_in([:url, :port], 80)
    |> put_in([:url, :host], value)
  end

  def apply_config(any, value, opts) when is_binary(value) do
    put_in(opts, [any], value)
  end
end

