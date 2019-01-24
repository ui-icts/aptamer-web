defmodule Aptamer.File do
  use AptamerWeb, :model
  alias Ecto.Multi
  alias Aptamer.Repo

  schema "files" do
    field :file_name, :string
    field :uploaded_on, :naive_datetime
    field :file_type, :string
    field :data, :binary

    belongs_to :owner, Aptamer.User
    has_many :jobs, Aptamer.Job

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:file_name, :uploaded_on, :file_type, :data, :owner_id])
    |> validate_required([:file_name, :uploaded_on, :file_type, :owner_id])
  end

  def delete(file) do
    jobs = Repo.all Ecto.assoc(file, :jobs)

    Multi.new
    |> delete_jobs(jobs, file)
    |> Multi.delete(:file, file)
  end

  def delete_jobs(multi, jobs, _) when jobs == [] do
    multi
  end

  def delete_jobs(multi, jobs, file) do
    create_graph_ids = unique_id_list(jobs, :create_graph_options_id)
    predict_structure_ids = unique_id_list(jobs, :predict_structure_options_id)
    
    create_graph_query = from cgo in Aptamer.CreateGraphOptions,
      where: cgo.id in ^create_graph_ids
    predict_structure_query = from pso in Aptamer.PredictStructureOptions,
      where: pso.id in ^predict_structure_ids

    multi
     |> Multi.delete_all(:results, Ecto.assoc(jobs, :results))
     |> Multi.delete_all(:jobs, Ecto.assoc(file, :jobs))
     |> Multi.delete_all(:create_graph_options, create_graph_query)
     |> Multi.delete_all(:predict_structure_options, predict_structure_query)
  end

  def unique_id_list(structList, id_name) do
    Enum.map(structList, fn struct -> Map.get(struct, id_name) end)
    |> Enum.filter(fn id -> id != nil end)
    |> Enum.uniq
  end
end
