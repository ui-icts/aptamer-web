defmodule Aptamer.Auth.UserTest do
  use Aptamer.DataCase, async: true
  import Aptamer.Factory

  alias Aptamer.Auth.User

  test "create from registration" do
    registration = build(:registration)
    changeset = User.register(registration)

    assert changeset.valid?

    user = Ecto.Changeset.apply_changes(changeset)

    assert Comeonin.Ecto.Password.valid?(registration.password, user.password)
  end
end
