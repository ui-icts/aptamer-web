defmodule Aptamer.Repo.Migrations.AddOutputToJob do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :output, :text
    end
  end
end
