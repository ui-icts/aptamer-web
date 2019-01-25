defmodule Aptamer.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:results, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:archive, :binary)
      add(:job_id, references(:jobs, on_delete: :nothing, type: :binary_id))

      timestamps()
    end

    create(index(:results, [:job_id]))
  end
end
