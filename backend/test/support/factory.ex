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
end
