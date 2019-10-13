defmodule Aptamer.Jobs.Result do
  use Ecto.Schema
  use Aptamer.BinaryIdColums
  use Aptamer.UtcMicroTimestamps
  import Ecto.Changeset

  schema "results" do
    field(:archive, :binary)
    belongs_to(:job, Aptamer.Jobs.Job)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:job_id, :archive])
    |> validate_required([:job_id, :archive])
  end
end
