defmodule Aptamer.Repo.Migrations.ChangeRunMfoldToToolName do
  use Ecto.Migration

  def change do
    alter table(:predict_structure_options) do
      add :tool_name, :string
      remove :run_mfold
    end
  end
end
