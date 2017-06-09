defmodule Aptamer.Repo.Migrations.AddPredictStructureOptionsToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :predict_structure_options_id, references(:predict_structure_options, on_delete: :nothing, type: :binary_id)
    end
  end
end
