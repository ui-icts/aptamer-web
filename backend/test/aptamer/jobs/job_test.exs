defmodule Aptamer.Jobs.JobTest do
  use Aptamer.DataCase, async: true
  import Aptamer.Factory

  alias Aptamer.Jobs.Job

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

  test "gives correct description" do
    file = build(:file, file_name: "1 quarter portion") |> as_structure |> insert
    ps_opts = build(:predict_structure_options) |> insert
    cg_opts = build(:create_graph_options) |> insert
    job = insert(:job, file: file, predict_structure_options: ps_opts, create_graph_options: nil)

    assert "predict structures for file 1 quarter portion" == Job.description(job)

    job = insert(:job, file: file, predict_structure_options: nil, create_graph_options: cg_opts)

    assert "create graph for file 1 quarter portion" == Job.description(job)
  end

  test "validating single set of options" do
    file = build(:file) |> as_structure |> insert
    job = build(:job)
    ps_opts = build(:predict_structure_options)
    cg_opts = build(:create_graph_options)

    cs = Job.changeset(job, %{file_id: file.id})
    assert cs.valid?

    no_options = cs

    both_options =
      cs
      |> Ecto.Changeset.put_assoc(:create_graph_options, cg_opts)
      |> Ecto.Changeset.put_assoc(:predict_structure_options, ps_opts)

    only_predict = cs |> Ecto.Changeset.put_assoc(:predict_structure_options, ps_opts)
    only_create = cs |> Ecto.Changeset.put_assoc(:create_graph_options, cg_opts)

    assert {:error, %Ecto.Changeset{valid?: false}} = Job.validate_only_one_options(no_options)
    assert {:error, %Ecto.Changeset{valid?: false}} = Job.validate_only_one_options(both_options)

    assert {:predict_structure_options, %Ecto.Changeset{valid?: true}} =
             Job.validate_only_one_options(only_predict)

    assert {:create_graph_options, %Ecto.Changeset{valid?: true}} =
             Job.validate_only_one_options(only_create)
  end
end
