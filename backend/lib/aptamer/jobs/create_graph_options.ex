defmodule Aptamer.Jobs.CreateGraphOptions do
  use Ecto.Schema
  use Aptamer.BinaryIdColums
  import Ecto.Changeset
  alias Aptamer.Jobs.CreateGraphOptions

  schema "create_graph_options" do
    field(:edge_type, :string)
    field(:seed, :boolean, default: false)
    field(:max_edit_distance, :integer)
    field(:max_tree_distance, :integer)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(%CreateGraphOptions{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:edge_type, :seed, :max_edit_distance, :max_tree_distance])
    |> validate_required([:edge_type, :seed, :max_edit_distance, :max_tree_distance])
  end

  @doc ~S"""
  Generates command line arguments that can
  be passed to System.cmd

  ## Examples

    iex> CreateGraphOptions.args(%CreateGraphOptions{edge_type: "both", seed: true, max_edit_distance: 3, max_tree_distance: 3})
    ["-t", "both", "-e", "3", "-d", "3", "--seed"]
    iex> CreateGraphOptions.args(%CreateGraphOptions{edge_type: "both", seed: true, max_edit_distance: 0, max_tree_distance: 3})
    ["-t", "both", "-e", "0", "-d", "3", "--seed"]
    iex> CreateGraphOptions.args(%CreateGraphOptions{edge_type: "both", seed: true, max_edit_distance: -1, max_tree_distance: 3})
    ["-t", "both", "-d", "3", "--seed"]
    iex> CreateGraphOptions.args(%CreateGraphOptions{edge_type: "both", seed: true, max_edit_distance: 2, max_tree_distance: 0})
    ["-t", "both", "-e", "2", "-d", "0", "--seed"]
    iex> CreateGraphOptions.args(%CreateGraphOptions{edge_type: "both", seed: true, max_edit_distance: 2, max_tree_distance: -1})
    ["-t", "both", "-e", "2", "--seed"]
  """
  def args(options) do
    edge_args = ["-t", options.edge_type]

    ed_args =
      case options.max_edit_distance do
        -1 -> []
        _ -> ["-e", to_string(options.max_edit_distance)]
      end

    td_args =
      case options.max_tree_distance do
        -1 -> []
        _ -> ["-d", to_string(options.max_tree_distance)]
      end

    seed_args =
      if options.seed do
        ["--seed"]
      else
        []
      end

    edge_args ++ ed_args ++ td_args ++ seed_args
  end
end
