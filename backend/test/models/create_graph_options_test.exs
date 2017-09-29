defmodule Aptamer.CreateGraphOptionsTest do
  use Aptamer.ModelCase

  alias Aptamer.CreateGraphOptions
  doctest Aptamer.CreateGraphOptions

  @valid_attrs %{edge_type: "some content", max_edit_distance: 42, max_tree_distance: 42, seed: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CreateGraphOptions.changeset(%CreateGraphOptions{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CreateGraphOptions.changeset(%CreateGraphOptions{}, @invalid_attrs)
    refute changeset.valid?
  end
end
