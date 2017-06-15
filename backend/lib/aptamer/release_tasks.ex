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

  defmodule Context do
    defstruct run_seeds: false
  end

  def bootstrap do

    IO.puts "Loading Aptamer.."
    case Application.load(:aptamer) do
      :ok -> :ok
      {:error, {:already_loaded, :aptamer}} -> :ok

    end

    context = %Context{}

    with {:ok, context} <- create_db(context),
         {:ok, context} <- migrate(context),
         {:ok, context} <- seed(context),
         {:ok, context} <- cleanup(context)
    do
      IO.puts "Database ready to go"
    else
      {:error, reason} -> IO.puts reason
     end
  end

  def create_db(context) do
    IO.puts "Checking if aptamer database needs to be created..."

    repo = Aptamer.Repo
    IO.puts "Database Configuration"
    IO.inspect repo.config

    config = get_repo_config(repo)

    case repo.__adapter__.storage_up(config) do
      :ok ->
        IO.puts "Database created"
        {:ok, %{context | run_seeds: true}}
      {:error, :already_up} ->
        IO.puts "Database already exists"
        {:ok, %{context | run_seeds: false}}

      {:error, "ERROR 42501" <> msg} ->
        # The database might already be there but we're not running as SU and no (easy) way to really
        # check if it is or not.
        # In this case we're going to pretend that it is there and and if it isn't then
        # migrations will not run.
        # We also disable seeds just in case
        IO.puts "User #{config[:username]} does not have permission to create databases. Database MIGHT NOT EXIST. ERROR 42501 #{msg}"
        {:ok, %{context | run_seeds: false}}

      {:error, term} when is_binary(term) ->
        {:error, "The database for #{inspect repo} couldn't be created: #{term}"}

      {:error, term} ->
        {:error, "The database for #{inspect repo} couldn't be created: #{inspect term}"}

    end

  end

  def migrate(context) do

    IO.puts "Starting dependencies.."
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for myapp
    IO.puts "Starting repos.."
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))

    # Run migrations
    Enum.each(@myapps, &run_migrations_for/1)

    {:ok, context}
  end

  def seed(%Context{run_seeds: true} = context) do
    # Run the seed script if it exists
    seed_script = Path.join([priv_dir(:aptamer), "repo", "seeds.exs"])

    if File.exists?(seed_script) do
      IO.puts "Running seed script.."
      Code.eval_file(seed_script)
    end
    {:ok, context}
  end

  def seed(context) do
    IO.puts "Not loading seeds"
    {:ok, context}
  end

  def cleanup(context) do
    {:init.stop(), context}
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do IO.puts "Running migrations for #{app}"
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
