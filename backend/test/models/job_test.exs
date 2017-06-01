defmodule Aptamer.JobTest do
  use Aptamer.ModelCase
  import Aptamer.Factory

  alias Aptamer.Job

  @valid_attrs %{status: "some content", file_id: 1}
  @invalid_attrs %{}

  setup do
    file = insert(:file)
    valid_attrs = Map.put(@valid_attrs, :file_id, file.id)
    {:ok, valid_attrs: valid_attrs}
  end
  test "changeset with valid attributes", %{valid_attrs: valid_attrs} do
    changeset = Job.changeset(%Job{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end

end
