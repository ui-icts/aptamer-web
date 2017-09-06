defmodule Aptamer.File do
  use Aptamer.Web, :model

  schema "files" do
    field :file_name, :string
    field :uploaded_on, :naive_datetime
    field :file_type, :string
    field :data, :binary

    belongs_to :owner, Aptamer.User
    has_one :create_graph_options, Aptamer.CreateGraphOptions
    has_many :jobs, Aptamer.Job

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:file_name, :uploaded_on, :file_type, :data, :owner_id])
    |> validate_required([:file_name, :uploaded_on, :file_type, :owner_id])
  end

  def delete(struct) do
    Ecto.Multi.new
  end
end
