defmodule Aptamer.UserTest do
  use Aptamer.ModelCase
  import Aptamer.Factory

  alias Aptamer.User

  test "create from registration" do
    registration = build(:registration)
    changeset = User.register(registration)
    IO.inspect changeset


    assert changeset.valid?

    user = Ecto.Changeset.apply_changes(changeset)

    assert Comeonin.Ecto.Password.valid?(registration.password, user.password)
  end
end
