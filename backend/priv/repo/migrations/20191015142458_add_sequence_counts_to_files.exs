defmodule Aptamer.Repo.Migrations.AddSequenceCountsToFiles do
  use Ecto.Migration

  def change do
    alter table(:files) do
      add :sequence_count, :integer
    end
  end
end
