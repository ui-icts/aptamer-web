defmodule Aptamer.Jobs.PredictStructureOptions do
  use Ecto.Schema
  use Aptamer.BinaryIdColums
  use Aptamer.UtcMicroTimestamps
  import Ecto.Changeset

  schema "predict_structure_options" do
    field(:tool_name, :string, default: "vienna")
    field(:vienna_version, :integer)
    field(:prefix, :string)
    field(:suffix, :string)
    field(:pass_options, :string)

    timestamps()
  end

  def default() do
    %Aptamer.Jobs.PredictStructureOptions{
      vienna_version: 2
    }
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tool_name, :vienna_version, :prefix, :suffix, :pass_options])
    |> validate_required([:tool_name, :vienna_version])
  end

  @doc ~S"""
  Generates command line arguments that can
  be passed to System.cmd

  ## Examples

    iex> Aptamer.Jobs.PredictStructureOptions.args(%PredictStructureOptions{tool_name: "vienna", vienna_version: 2, prefix: "PP", suffix: "SS", pass_options: ""})
    ["-v", "2", "--prefix", "PP", "--suffix", "SS"]
    iex> Aptamer.Jobs.PredictStructureOptions.args(%PredictStructureOptions{tool_name: "mfold", vienna_version: 1, prefix: "PP", suffix: "SS", pass_options: "-T 37 -p"})
    ["--run_mfold", "--prefix", "PP", "--suffix", "SS","--pass_options",~s( -T 37 -p)]
    iex> Aptamer.Jobs.PredictStructureOptions.args(%PredictStructureOptions{tool_name: "mfold", vienna_version: 1, prefix: "PP", suffix: "SS", pass_options: ""})
    ["--run_mfold", "--prefix", "PP", "--suffix", "SS"]
    iex> Aptamer.Jobs.PredictStructureOptions.args(%PredictStructureOptions{tool_name: "vienna", vienna_version: 2, prefix: "", suffix: "", pass_options: ""})
    ["-v", "2"]
    iex> Aptamer.Jobs.PredictStructureOptions.args(%PredictStructureOptions{tool_name: "vienna", vienna_version: 2, prefix: "PP", suffix: nil, pass_options: ""})
    ["-v", "2", "--prefix", "PP"]
  """
  def args(options) do
    pass_args =
      if missing?(options.pass_options) do
        []
      else
        ["--pass_options", " " <> ensure_dash_p(options.pass_options)]
      end

    prefix_args = ix_args("prefix", options.prefix)
    suffix_args = ix_args("suffix", options.suffix)
    common_args = prefix_args ++ suffix_args

    tool_args =
      if options.tool_name == "mfold" do
        ["--run_mfold"]
      else
        ["-v", to_string(options.vienna_version)]
      end

    tool_args ++ common_args ++ pass_args
  end

  defp ensure_dash_p(pass_options) do
    parts = String.split(pass_options)

    if "-p" not in parts do
      pass_options <> " -p"
    else
      pass_options
    end
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
