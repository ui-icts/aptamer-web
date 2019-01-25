defmodule Aptamer.Jobs.CreateGraphOptionsTest do
  use Aptamer.DataCase

  alias Aptamer.Jobs.CreateGraphOptions
  doctest Aptamer.Jobs.CreateGraphOptions

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
