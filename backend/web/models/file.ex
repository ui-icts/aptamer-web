defmodule Aptamer.File do
  use Aptamer.Web, :model

  schema "files" do
    field :file_name, :string
    field :uploaded_on, :naive_datetime
    field :file_type, :string
    field :data, :binary
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:file_name, :uploaded_on, :file_type, :data])
    |> validate_required([:file_name, :uploaded_on, :file_type])
  end
end
