defmodule Aptamer.PredictStructureOptions do
  use Aptamer.Web, :model

  schema "predict_structure_options" do
    field :run_mfold, :boolean, default: false
    field :vienna_version, :integer
    field :prefix, :string
    field :suffix, :string
    field :pass_options, :string
    belongs_to :file, Aptamer.File

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:run_mfold, :vienna_version, :prefix, :suffix, :pass_options, :file_id])
    |> cast_assoc(:file)
    |> validate_required([:run_mfold, :vienna_version, :prefix, :suffix, :pass_options])
  end
end
