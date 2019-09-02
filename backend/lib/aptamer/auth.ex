defmodule Aptamer.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Aptamer.Repo

  alias Aptamer.Auth.User

  def list_users() do
    Repo.all(User)
    |> Enum.map(fn u ->
      Map.take(u, [:name, :email, :updated_at])
    end)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def change_password(email_address, new_password) do

    user =
      User
      |> where(email: ^email_address)
      |> Repo.one!()

    cs = User.changeset(user, %{password: new_password})
    if cs.valid? do
      Repo.update(cs)
    else
      {:error, cs}
    end
  end
end
