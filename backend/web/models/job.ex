defmodule Aptamer.Job do
  use Aptamer.Web, :model

  schema "jobs" do
    field :status, :string
    belongs_to :file, Aptamer.File
    belongs_to :create_graph_options, Aptamer.CreateGraphOptions

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :file_id, :create_graph_options_id])
    |> validate_required([:status, :file_id])
  end
end
