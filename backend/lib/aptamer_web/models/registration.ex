defmodule Aptamer.Registration do
  use AptamerWeb, :model

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
