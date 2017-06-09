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
    |> validate_required([:run_mfold, :vienna_version, :prefix, :suffix])
  end

  @doc ~S"""
  Generates command line arguments that can
  be passed to System.cmd

  ## Examples
  
    iex> PredictStructureOptions.args(%PredictStructureOptions{run_mfold: false, vienna_version: 2, prefix: "PP", suffix: "SS", pass_options: ""})
    ["-v", "2", "--prefix", "PP", "--suffix", "SS"]
    iex> PredictStructureOptions.args(%PredictStructureOptions{run_mfold: true, vienna_version: 1, prefix: "PP", suffix: "SS", pass_options: "-foo -bar"})
    ["--run_mfold", "--prefix", "PP", "--suffix", "SS","--pass_options","-foo -bar"]
    iex> PredictStructureOptions.args(%PredictStructureOptions{run_mfold: true, vienna_version: 1, prefix: "PP", suffix: "SS", pass_options: ""})
    ["--run_mfold", "--prefix", "PP", "--suffix", "SS"]
  """
  def args(options) do

    pass_args = if missing?(options.pass_options) do
      []
    else
      ["--pass_options", options.pass_options]
    end

    common_args = [
      "--prefix", options.prefix,
      "--suffix", options.suffix,
    ]

    tool_args = if options.run_mfold do
      ["--run_mfold"]
    else
      ["-v",to_string(options.vienna_version)]
    end

    tool_args ++ common_args ++ pass_args
  end
  
  defp missing?(thing) do
    case thing do
      "" -> true
      nil -> true
      _ -> false
    end
  end
end
