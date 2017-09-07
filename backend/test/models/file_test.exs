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

  test "delete a file with all associations" do
    file = build(:file) |> as_structure |> insert
    cg_opts = build(:create_graph_options) |> for_file(file) |> insert
    ps_opts = build(:predict_structure_options) |> for_file(file) |> insert
    job = insert(:job, file: file, predict_structure_options: ps_opts, create_graph_options: cg_opts)

    multi = File.delete(file)

    assert [
      {:create_graph_options, {:delete_all, cg_query, []}},
      {:predict_structure_options, {:delete_all, ps_query, []}},
      {:jobs, {:delete_all, j_query, []}},
      {:files, {:delete, file, []}}
    ] = Ecto.Multi.to_list(multi)

    {:ok, _} = Repo.transaction(multi)

    assert Repo.get(File, file.id) == nil
  end
end
