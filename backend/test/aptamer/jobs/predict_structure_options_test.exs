defmodule Aptamer.Jobs.PredictStructureOptionsTest do
  use Aptamer.DataCase, async: true

  alias Aptamer.Jobs.PredictStructureOptions

  doctest Aptamer.Jobs.PredictStructureOptions

  @valid_attrs %{
    pass_options: "some content",
    prefix: "some content",
    run_mfold: true,
    suffix: "some content",
    vienna_version: 42
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PredictStructureOptions.changeset(%PredictStructureOptions{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PredictStructureOptions.changeset(%PredictStructureOptions{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "Adds the -p with pass_options if it is not specified" do
    example = %PredictStructureOptions{
      prefix: "",
      suffix: "",
      run_mfold: false,
      vienna_version: 2,
      pass_options: "-T 37"
    }

    args = PredictStructureOptions.args(example)
    assert " -T 37 -p" == List.last(args)
  end
end
