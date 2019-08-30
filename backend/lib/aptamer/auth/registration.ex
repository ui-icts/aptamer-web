defmodule Aptamer.Auth.Registration do
  use Ecto.Schema
  use Aptamer.BinaryIdColums
  import Ecto.Changeset

  schema "registration" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string)
  end

  def blank(), do: changeset(__MODULE__.__struct__)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
  end

  def new_user(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
    |> validate_confirmation(:password, required: true, message: "does not match password")
  end
end
