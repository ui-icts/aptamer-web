defmodule Aptamer.Repo.Migrations.AddBatchSizeAndSpawnColumns do
  use Ecto.Migration

  def change do
    alter table(:create_graph_options) do
      add(:spawn, :boolean, default: true, null: false)
      add(:batch_size, :integer, default: 10_000, null: false)
    end

  end
end
