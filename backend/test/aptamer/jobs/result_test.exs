defmodule Aptamer.Jobs.ResultTest do
  use Aptamer.DataCase

  alias Aptamer.Jobs.Result

  @valid_attrs %{job_id: "1", archive: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Result.changeset(%Result{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Result.changeset(%Result{}, @invalid_attrs)
    refute changeset.valid?
  end
end
