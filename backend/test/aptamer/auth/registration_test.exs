defmodule Aptamer.Auth.RegistrationTest do
  use Aptamer.DataCase, async: true

  alias Aptamer.Auth.Registration

  @valid_attrs %{email: "bob@example.com", name: "Bob", password: "welcome"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Registration.changeset(%Registration{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Registration.changeset(%Registration{}, @invalid_attrs)
    refute changeset.valid?
  end
end
