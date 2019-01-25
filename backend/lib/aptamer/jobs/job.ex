defmodule Aptamer.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aptamer.Repo
  alias Aptamer.Jobs.{File,Job}

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "jobs" do
    field :status, :string
    field :output, :string
    belongs_to :file, Aptamer.Jobs.File
    belongs_to :create_graph_options, Aptamer.Jobs.CreateGraphOptions
    belongs_to :predict_structure_options, Aptamer.Jobs.PredictStructureOptions
    has_one :results, Aptamer.Jobs.Result
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :output, :file_id, :create_graph_options_id, :predict_structure_options_id])
    |> validate_required([:status, :file_id])
  end

  def description(job) when not is_nil(job) do
    file_name = Repo.get!(Aptamer.Jobs.File, job.file_id).file_name

    cond do
      job.create_graph_options_id != nil -> "create graph for file " <> file_name
      job.predict_structure_options_id != nil -> "predict structures for file " <> file_name
    end
  end
end
