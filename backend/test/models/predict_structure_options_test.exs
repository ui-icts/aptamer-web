defmodule Aptamer.PredictStructureOptionsTest do
  use Aptamer.ModelCase

  alias Aptamer.PredictStructureOptions

  @valid_attrs %{pass_options: "some content", prefix: "some content", run_mfold: true, suffix: "some content", vienna_version: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PredictStructureOptions.changeset(%PredictStructureOptions{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PredictStructureOptions.changeset(%PredictStructureOptions{}, @invalid_attrs)
    refute changeset.valid?
  end
end
