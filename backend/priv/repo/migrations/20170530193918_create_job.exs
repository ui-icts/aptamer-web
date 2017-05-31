defmodule Aptamer.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string
      add :file_id, references(:files, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:jobs, [:file_id])

  end
end
