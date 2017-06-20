defmodule Aptamer.User do
  use Aptamer.Web, :model

  alias Aptamer.{Registration,User}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, Comeonin.Ecto.Password
    has_many :files, Aptamer.File, foreign_key: "owner_id"

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email])
    |> cast(params, ~w(password))
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def register(%Registration{} = reg) do
    %User{name: reg.name,email: reg.email}
    |> changeset(%{password: reg.password})
  end
end