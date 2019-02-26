defmodule Aptamer.Repo.Migrations.CreateCreateGraphOptions do
  use Ecto.Migration

  def change do
    create table(:create_graph_options, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:edge_type, :string)
      add(:seed, :boolean, default: false, null: false)
      add(:max_edit_distance, :integer)
      add(:max_tree_distance, :integer)
      add(:file_id, references(:files, on_delete: :nothing, type: :binary_id))

      timestamps()
    end
  end
end
