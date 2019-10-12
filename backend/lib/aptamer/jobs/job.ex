defmodule Aptamer.Jobs.Job do
  @moduledoc """
  In order to process a file with one of the python scripts you need
  the file itself and the set of command line arguments you want to use.

  A job represents that association and tracks the progress of excecuting
  the script and holds the computed results
  """

  use Ecto.Schema
  use Aptamer.BinaryIdColums
  import Ecto.Changeset
  alias Aptamer.Repo

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "jobs" do
    field(:status, :string)
    field(:output, :string)
    belongs_to(:file, Aptamer.Jobs.File)
    belongs_to(:create_graph_options, Aptamer.Jobs.CreateGraphOptions)
    belongs_to(:predict_structure_options, Aptamer.Jobs.PredictStructureOptions)
    has_one(:results, Aptamer.Jobs.Result)
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :status,
      :output,
      :file_id,
      :create_graph_options_id,
      :predict_structure_options_id
    ])
    |> validate_required([:status, :file_id])
  end

  def description(job) when not is_nil(job) do
    file_name = Repo.get!(Aptamer.Jobs.File, job.file_id).file_name

    cond do
      job.create_graph_options_id != nil -> "create graph for file " <> file_name
      job.predict_structure_options_id != nil -> "predict structures for file " <> file_name
    end
  end

  def validate_only_one_options(changeset) do
    option_changes = [
      get_change(changeset, :create_graph_options, :missing),
      get_change(changeset, :predict_structure_options, :missing)
    ]

    case option_changes do
      [:missing, :missing] ->
        {:error,
         changeset
         |> add_error(:create_graph_options, "Job should have at least 1 set of options")
         |> add_error(:predict_structure_options, "Job should have at least 1 set of options")}

      [_some, :missing] ->
        {:create_graph_options, changeset}

      [:missing, _some] ->
        {:predict_structure_options, changeset}

      [_some1, _some2] ->
        {:error,
         add_error(changeset, :create_graph_options, "Job can only have one set of options")}
    end
  end
end
