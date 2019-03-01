defmodule EnvConfigTest do
  use Aptamer.DataCase
  
  import Aptamer.EnvConfig

  test "Updates both http and url keys" do
    assert [http: [port: 80], url: [port: 80]] == apply_config(:port, "80", [])
  end

  test "replaces existing value" do
    # I think that url shows up here first because it doesn't already exist
    # in the list I pass as an argument to the function
    # Order is not significant though, so don't take that as something required
    # I just don't have a better way to assert the keyword list
    assert [url: [port: 80],http: [port: 80] ] = apply_config(:port, "80", [http: [port: 1]])
  end

  test "doesnt nuke existing options" do
    assert [url: [port: 80],http: [host: "example.com", port: 80] ] = apply_config(:port, "80", [http: [host: "example.com", port: 1]])
  end

  test "adds webhost to url list" do
    assert [url: [host: "example.com"]] == apply_config(:web_host, "example.com", [])
  end

  test "applying a nil value gives existing options back" do
    assert [a: 1] == apply_config(:whatever, nil, [a: 1])
  end

  test "overrides web info from system environment" do
    existing_opts = Application.get_env(:aptamer, AptamerWeb.Endpoint)
    :ok = System.put_env([{"WEB_HOST", "example.com"}, {"PORT", "8080"}, {"SECRET_KEY_BASE", "XXXOOO"}])
    new_opts = override_endpoint_config(System.get_env(), existing_opts)

    assert "example.com" == get_in(new_opts, [:url,:host])
    assert 8080 == get_in(new_opts, [:url, :port])
    assert 8080 == get_in(new_opts, [:http, :port])
    assert "XXXOOO" == get_in(new_opts, [:secret_key_base])
  end

  test "overrides database connection props from system environment" do

    existing_opts = Application.get_env(:aptamer, Aptamer.Repo)
    new_opts = override_repo_config(%{"DATABASE_HOST" => "db-host.local"}, existing_opts)
    assert "db-host.local" == new_opts[:hostname]

    new_opts = override_repo_config(%{
      "DATABASE_USER" => "test_user",
      "DATABASE_PASSWORD" => "test_password",
      "DATABASE_NAME" => "test_database"
    }, existing_opts)

    assert "test_user" == new_opts[:username]
    assert "test_password" == new_opts[:password]
    assert "test_database" == new_opts[:database]
  end

  test "overrides smtp settings" do

    existing_opts = Application.get_env(:aptamer, Aptamer.Mailer)
    new_opts = override_smtp_config(%{"SMTP_PASSWORD" => "email_passworder"}, existing_opts)
    assert "email_passworder" == new_opts[:password]
  end

  @doc """
  This is equivalent to 
  export FOO=
  In elixir it will be empty string in env var map
  """
  test "blank env vars wipe settings" do

    existing_opts = Application.get_env(:aptamer, Aptamer.Mailer)
    new_opts = override_smtp_config(%{"SMTP_PASSWORD" => ""}, existing_opts)
    assert "" == new_opts[:password]
  end
end
