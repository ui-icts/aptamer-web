defmodule Aptamer.Factory do
  use ExMachina.Ecto, repo: Aptamer.Repo

  def file_factory do
    %Aptamer.File{
      file_name: "test.txt",
      uploaded_on: "2016-12-05T10:00:00.000000Z",
      file_type: "UNKNOWN"
    }
  end

  def as_structure(file) do
    %{file | file_type: "structure"}
  end

  def as_fasta(file) do
    %{file | file_type: "fasta"}
  end

  def with_running_job(file) do
    %{file | jobs: build(:job)}
  end

  def job_factory do
    %Aptamer.Job{
      status: "not-started",
      file: build(:file)
    }
  end

  def create_graph_options_factory do
    %Aptamer.CreateGraphOptions {
      edge_type: "tree",
      seed: true,
      max_edit_distance: 3,
      max_tree_distance: 4,
      file: nil
    }
  end

  def for_file(%Aptamer.CreateGraphOptions{} = options, file) do

    %{ options | file: file }
  end
end
