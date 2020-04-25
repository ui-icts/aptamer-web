defmodule Aptamer.Jobs.FileTest do
  use Aptamer.DataCase, async: true

  import Aptamer.Factory
  alias Aptamer.Jobs.File


  @valid_attrs %{
    file_name: "some content",
    file_type: "some content",
    uploaded_on: ~N[2000-01-01 23:00:07]
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    valid_attrs = Map.put(@valid_attrs, :owner_id, insert(:user).id)
    changeset = File.changeset(%File{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "delete a file with all associations" do
    file = build(:file) |> as_structure |> insert
    cg_opts = build(:create_graph_options) |> insert
    ps_opts = build(:predict_structure_options) |> insert

    _job =
      insert(:job,
        file: file,
        predict_structure_options: ps_opts,
        create_graph_options: cg_opts
      )

    file = Repo.get!(File, file.id)
    multi = Aptamer.Jobs.delete_file(file)

    {:ok, _} = Repo.transaction(multi)

    assert Repo.get(File, file.id) == nil
  end

  test "delete a file with some associations" do
    file = build(:file) |> as_structure |> insert
    ps_opts = build(:predict_structure_options) |> insert
    _job = insert(:job, file: file, predict_structure_options: ps_opts, create_graph_options: nil)

    multi = Aptamer.Jobs.delete_file(file)

    {:ok, _} = Repo.transaction(multi)

    assert Repo.get(File, file.id) == nil
  end

  test "delete a file with no jobs" do
    # This winds up a special case because if the options aren't
    # linked to a job then we might not find them dependening on
    # how the delete gets implemented, so just a case to make
    # sure we're covered
    file = build(:file) |> as_structure |> insert

    multi = Aptamer.Jobs.delete_file(file)

    {:ok, _} = Repo.transaction(multi)

    assert Repo.get(File, file.id) == nil
  end

  test "returns a unique list of all specified, non-nil keys in a struct" do
    jobs1 = [
      %Aptamer.Jobs.Job{:create_graph_options_id => 4, :predict_structure_options_id => nil},
      %Aptamer.Jobs.Job{:create_graph_options_id => 8, :predict_structure_options_id => -2},
      %Aptamer.Jobs.Job{:create_graph_options_id => 4, :predict_structure_options_id => 00},
      %Aptamer.Jobs.Job{:create_graph_options_id => 0, :predict_structure_options_id => 83},
      %Aptamer.Jobs.Job{:create_graph_options_id => nil, :predict_structure_options_id => 0}
    ]

    assert [4, 8, 0] = Aptamer.Jobs.unique_id_list(jobs1, :create_graph_options_id)
    assert [-2, 0, 83] = Aptamer.Jobs.unique_id_list(jobs1, :predict_structure_options_id)
  end

  describe "#build_script_args" do
    test "fails if no options" do
      job = build(:job)
      assert {:error, _} = File.build_script_args(job)
    end

    test "selects script by options" do
      job = build(:job)

      assert {"predict_structures.py", _, _} =
               File.build_script_args(%{
                 job
                 | predict_structure_options: build(:predict_structure_options)
               })

      assert {"create_graph.py", _, _} =
               File.build_script_args(%{job | create_graph_options: build(:create_graph_options)})
    end
  end

  describe "#guess_file_type" do
    test "is fasta if 3rd line starts with >" do
      file_contents = """
      >2	SIZE=2
      AAACATGCATCATCAGGTAAGTACGGTCCC
      >3	SIZE=2
      AAAGCATCAGTGCAAGTCGTTGGCCCC
      >4	SIZE=5
      AAAGCCACAGATATCTCCCCTGTTGCTCCC
      >5	SIZE=23
      AAAGGTCCTCGTATTGCACGTACTGCGCCC
      >6	SIZE=2
      AAAGTCTGGGCTATGACTCTTTACCCCCCCC
      """

      assert "fasta" == File.guess_file_type(file_contents)
    end

    test "is structure when 3rd line is dot graph" do

      file_contents = """
      >2
      AAACATGCATCATCAGGTAAGTACGGTCCC
      ..............................
      >3
      AAAGCATCAGTGCAAGTCGTTGGCCCC
      ...(((....)))..............
      >4
      AAAGCCACAGATATCTCCCCTGTTGCTCCC
      ..(((.((((.........)))).)))...
      >5
      """

      assert "structure" == File.guess_file_type(file_contents)
    end
  end
end
