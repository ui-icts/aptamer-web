defmodule Aptamer.CreateGraphOptions do
  use Aptamer.Web, :model

  schema "create_graph_options" do
    field :edge_type, :string
    field :seed, :boolean, default: false
    field :max_edit_distance, :integer
    field :max_tree_distance, :integer
    belongs_to :file, Aptamer.File

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:edge_type, :seed, :max_edit_distance, :max_tree_distance, :file_id])
    |> cast_assoc(:file)
    |> validate_required([:edge_type, :seed, :max_edit_distance, :max_tree_distance])
  end
end
