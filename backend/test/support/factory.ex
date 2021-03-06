defmodule Aptamer.Factory do
  use ExMachina.Ecto, repo: Aptamer.Repo

  def registration_factory do
    %Aptamer.Auth.Registration{
      name: sequence(:user, &"User #{&1}"),
      email: sequence(:user, &"user#{&1}@example.com"),
      password: "welcome"
    }
  end

  def user_factory do
    {:ok, password} = Comeonin.Ecto.Password.cast("welcome")

    %Aptamer.Auth.User{
      name: sequence(:user, &"User #{&1}"),
      email: sequence(:user, &"user#{&1}@example.com"),
      password: password
    }
  end

  def file_factory do
    %Aptamer.Jobs.File{
      file_name: "test.txt",
      uploaded_on: "2016-12-05T10:00:00.000000Z",
      file_type: "UNKNOWN",
      owner: build(:user)
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
    %Aptamer.Jobs.Job{
      id: Ecto.UUID.generate(),
      status: "not-started",
      file: build(:file),
      predict_structure_options: nil,
      create_graph_options: nil
    }
  end

  def create_graph_options_factory do
    %Aptamer.Jobs.CreateGraphOptions{
      edge_type: "tree",
      seed: true,
      max_edit_distance: 3,
      max_tree_distance: 4,
      batch_size: 10_000,
      spawn: true
    }
  end

  def predict_structure_options_factory do
    %Aptamer.Jobs.PredictStructureOptions{
      run_mfold: false,
      vienna_version: 2,
      prefix: "PP",
      suffix: "SS",
      pass_options: "-foo -bar"
    }
  end
end
