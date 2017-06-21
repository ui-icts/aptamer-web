defmodule Aptamer.FileTest do
  use Aptamer.ModelCase

  import Aptamer.Factory
  alias Aptamer.File

  @valid_attrs %{file_name: "some content", file_type: "some content", uploaded_on: ~N[2000-01-01 23:00:07]}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    valid_attrs = Map.put(@valid_attrs, :owner_id, insert(:user).id )
    changeset = File.changeset(%File{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, @invalid_attrs)
    refute changeset.valid?
  end
end
