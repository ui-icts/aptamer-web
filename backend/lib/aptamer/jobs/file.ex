defmodule Aptamer.Jobs.File do
  use Ecto.Schema
  use Aptamer.BinaryIdColums
  import Ecto.Changeset
  import Ecto.Query
  alias Ecto.Multi
  alias Aptamer.Repo
  alias Aptamer.Jobs.{File, CreateGraphOptions, PredictStructureOptions}

  schema "files" do
    field(:file_name, :string)
    field(:uploaded_on, :naive_datetime)
    field(:file_type, :string)
    field(:data, :binary)

    belongs_to(:owner, Aptamer.Auth.User)
    has_many(:jobs, Aptamer.Jobs.Job)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(%File{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:file_name, :uploaded_on, :file_type, :data, :owner_id])
    |> validate_required([:file_name, :uploaded_on, :file_type, :owner_id])
  end

  def new_structure_file_changeset(file_name, contents, owner_id) do
    changeset(%File{}, %{
      file_name: file_name,
      data: contents,
      owner_id: owner_id,
      file_type: "structure",
      uploaded_on: DateTime.utc_now()
    })
  end

  def delete(file) do
    jobs = Repo.all(Ecto.assoc(file, :jobs))

    Multi.new()
    |> delete_jobs(jobs, file)
    |> Multi.delete(:file, file)
  end

  def delete_jobs(multi, jobs, _) when jobs == [] do
    multi
  end

  def delete_jobs(multi, jobs, file) do
    create_graph_ids = unique_id_list(jobs, :create_graph_options_id)
    predict_structure_ids = unique_id_list(jobs, :predict_structure_options_id)

    create_graph_query = from(cgo in CreateGraphOptions, where: cgo.id in ^create_graph_ids)

    predict_structure_query =
      from(pso in PredictStructureOptions, where: pso.id in ^predict_structure_ids)

    multi
    |> Multi.delete_all(:results, Ecto.assoc(jobs, :results))
    |> Multi.delete_all(:jobs, Ecto.assoc(file, :jobs))
    |> Multi.delete_all(:create_graph_options, create_graph_query)
    |> Multi.delete_all(:predict_structure_options, predict_structure_query)
  end

  def unique_id_list(structList, id_name) do
    Enum.map(structList, fn struct -> Map.get(struct, id_name) end)
    |> Enum.filter(fn id -> id != nil end)
    |> Enum.uniq()
  end
end
