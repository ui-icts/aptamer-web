defmodule Aptamer.Repo.Migrations.CreatePredictStructureOptions do
  use Ecto.Migration

  def change do
    create table(:predict_structure_options, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :run_mfold, :boolean, default: false, null: false
      add :vienna_version, :integer
      add :prefix, :string
      add :suffix, :string
      add :pass_options, :string

      timestamps()
    end

  end
end
