defmodule Aptamer.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :file_name, :string
      add :uploaded_on, :naive_datetime
      add :file_purpose, :string
      add :data, :bytea
      timestamps()
    end

  end
end
