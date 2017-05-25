defmodule Aptamer.Repo.Migrations.RenameFilePurposeToType do
  use Ecto.Migration

  def change do
    rename table(:files), :file_purpose, to: :file_type
  end
end
