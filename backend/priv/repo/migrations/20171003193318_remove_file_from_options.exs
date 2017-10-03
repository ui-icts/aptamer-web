defmodule Aptamer.Repo.Migrations.RemoveFileFromOptions do
  use Ecto.Migration

  def change do
    alter table(:create_graph_options) do
      remove :file_id
    end

    alter table(:predict_structure_options) do
      remove :file_id
    end
  end
end
