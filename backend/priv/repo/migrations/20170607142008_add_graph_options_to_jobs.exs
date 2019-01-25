defmodule Aptamer.Repo.Migrations.AddGraphOptionsToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add(
        :create_graph_options_id,
        references(:create_graph_options, on_delete: :nothing, type: :binary_id)
      )
    end
  end
end
