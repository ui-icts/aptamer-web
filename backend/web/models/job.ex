defmodule Aptamer.Job do
  use Aptamer.Web, :model

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "jobs" do
    field :status, :string
    field :output, :string
    belongs_to :file, Aptamer.File
    belongs_to :create_graph_options, Aptamer.CreateGraphOptions

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :output, :file_id, :create_graph_options_id])
    |> validate_required([:status, :file_id])
  end
end
