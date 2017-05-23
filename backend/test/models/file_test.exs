defmodule Aptamer.FileTest do
  use Aptamer.ModelCase

  alias Aptamer.File

  @valid_attrs %{file_name: "some content", file_purpose: "some content", uploaded_on: ~N[2000-01-01 23:00:07]}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, @valid_attrs)
    IO.inspect changeset.errors
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, @invalid_attrs)
    refute changeset.valid?
  end
end
