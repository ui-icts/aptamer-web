defmodule Aptamer.ReleaseTasks do

  @start_apps [
    :postgrex,
    :ecto
  ]

  @myapps [
    :aptamer
  ]

  @repos [
    Aptamer.Repo
  ]

  def bootstrap do

    :ok = Application.load(:aptamer)

    repo = Aptamer.Repo
    config = get_repo_config(repo)

    case repo.__adapter__.storage_up(config) do
      :ok ->
        IO.puts "Database created"
        :ok
      {:error, :already_up} ->
        IO.puts "Database already exists"
        :ok

      {:error, term} when is_binary(term) ->
        raise "The database for #{inspect repo} couldn't be created: #{term}"
      {:error, term} ->
        raise "The database for #{inspect repo} couldn't be created: #{inspect term}"
    end
  end

  def migrate do
    IO.puts "Loading Aptamer.."
    # Load the code for myapp, but don't start it
    :ok = Application.load(:aptamer)

    IO.puts "Starting dependencies.."
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for myapp
    IO.puts "Starting repos.."
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))

    # Run migrations
    Enum.each(@myapps, &run_migrations_for/1)

    # Run the seed script if it exists
    seed_script = Path.join([priv_dir(:aptamer), "repo", "seeds.exs"])
    if File.exists?(seed_script) do
      IO.puts "Running seed script.."
      Code.eval_file(seed_script)
    end

    # Signal shutdown
    IO.puts "Success!"
    :init.stop()
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(Aptamer.Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
  defp seed_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])

  defp get_repo_config(repo) do

     case {System.get_env("DB_SUPERUSER"), System.get_env("DB_SUPERPASS")} do
      {user,pass} when is_binary(user) and is_binary(pass) ->
        repo.config
        |> List.keyreplace(:username,0,{:username, user})
        |> List.keyreplace(:password,0,{:password, pass})
      _ ->
        repo.config
    end
  end
end
