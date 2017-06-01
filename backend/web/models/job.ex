defmodule Aptamer.Job do
  use Aptamer.Web, :model

  schema "jobs" do
    field :status, :string
    belongs_to :file, Aptamer.File

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :file_id])
    |> validate_required([:status, :file_id])
  end
end
