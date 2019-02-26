defmodule Aptamer.Repo.Migrations.FileForPredictStructures do
  use Ecto.Migration

  def change do
    alter table(:predict_structure_options) do
      add(:file_id, references(:files, on_delete: :nothing, type: :binary_id))
    end
  end
end
