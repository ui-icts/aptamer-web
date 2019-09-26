defmodule Aptamer.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Aptamer.Repo

  alias Aptamer.Jobs.{File, Job}

  require Logger

  def list_files(current_user) do
    query =
      from(file in File,
        left_join: jobs in assoc(file, :jobs),
        where: file.owner_id == ^current_user.id,
        order_by: :uploaded_on,
        preload: [jobs: jobs]
      )

    files = Repo.all(query)
  end

  def view_file(file_id) do
    query =
      from(file in File,
        left_join: jobs in assoc(file, :jobs),
        preload: [jobs: jobs]
      )

    Repo.get(query, file_id)
  end

  def create_new_job(:create_graph, file, options_params) do
    params =
      Map.merge(%{"create_graph_options" => options_params}, %{
        "id" => Ecto.UUID.generate(),
        "file_id" => file.id,
        "status" => "ready"
      })

    cs =
      %Job{}
      |> cast(params, [:id, :file_id, :status])
      |> cast_assoc(:create_graph_options)

    # |> cast_assoc(:predict_structure_options)

    if cs.valid? do
      try do
        case Repo.insert(cs) do
          {:ok, job} ->
            file = Repo.preload(file, :jobs, force: true)
            {:ok, file, job}

          {:error, cs} ->
            {:ok, options_changes} = Ecto.Changeset.fetch_change(cs, :create_graph_options)
            IO.inspect(cs)
            {:error, "Unable to start job", options_changes}
        end
      rescue
        error in [Postgrex.Error] ->
          Logger.error("Unable to save job")
          Logger.error(Exception.format(:error, error, __STACKTRACE__))

          {:ok, options_changes} = Ecto.Changeset.fetch_change(cs, :create_graph_options)
          {:error, "Error creating job", options_changes}
      end
    else
      {:ok, options_changes} = Ecto.Changeset.fetch_change(cs, :create_graph_options)
      {:invalid, options_changes}
    end
  end
end
