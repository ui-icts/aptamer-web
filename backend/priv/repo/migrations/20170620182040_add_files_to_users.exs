defmodule Aptamer.Repo.Migrations.AddFilesToUsers do
  use Ecto.Migration

  def change do
    alter table(:files) do
      add :owner_id, references(:users, on_delete: :delete_all, type: :binary_id)
    end
  end
end
