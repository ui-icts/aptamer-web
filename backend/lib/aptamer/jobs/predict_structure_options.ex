defmodule Aptamer.Jobs.PredictStructureOptions do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aptamer.Jobs.PredictStructureOptions

  schema "predict_structure_options" do
    field :run_mfold, :boolean, default: false
    field :vienna_version, :integer
    field :prefix, :string
    field :suffix, :string
    field :pass_options, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:run_mfold, :vienna_version, :prefix, :suffix, :pass_options])
    |> validate_required([:run_mfold, :vienna_version])
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
    iex> PredictStructureOptions.args(%PredictStructureOptions{run_mfold: false, vienna_version: 2, prefix: "", suffix: "", pass_options: ""})
    ["-v", "2"]
    iex> PredictStructureOptions.args(%PredictStructureOptions{run_mfold: false, vienna_version: 2, prefix: "PP", suffix: nil, pass_options: ""})
    ["-v", "2", "--prefix", "PP"]
  """
  def args(options) do

    pass_args = if missing?(options.pass_options) do
      []
    else
      ["--pass_options", options.pass_options]
    end

    prefix_args = ix_args("prefix", options.prefix)
    suffix_args = ix_args("suffix", options.suffix)
common_args = prefix_args ++ suffix_args

    tool_args = if options.run_mfold do
      ["--run_mfold"]
    else
      ["-v",to_string(options.vienna_version)]
    end

    tool_args ++ common_args ++ pass_args
  end
  
  defp ix_args(which, value) do
    case value do
      "" -> []
      nil -> []
      _ -> ["--#{which}", value]

    end

  end

  defp missing?(thing) do
    case thing do
      "" -> true
      nil -> true
      _ -> false
    end
  end
end
