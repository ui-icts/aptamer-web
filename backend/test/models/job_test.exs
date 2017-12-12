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

  test "gives correct description" do
    file = build(:file, file_name: "1 quarter portion") |> as_structure |> insert
    ps_opts = build(:predict_structure_options) |> insert
    cg_opts = build(:create_graph_options) |> insert
    job = insert(:job, file: file, predict_structure_options: ps_opts, create_graph_options: nil)

    assert "predict structures for file 1 quarter portion" == Job.description(job)

    job = insert(:job, file: file, predict_structure_options: nil, create_graph_options: cg_opts)
    
    assert "create graph for file 1 quarter portion" == Job.description(job)
  end

end
