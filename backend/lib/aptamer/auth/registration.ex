defmodule Aptamer.Auth.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registration" do
    field :email, :string
    field :name, :string
    field :password, :string
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
  end

end
