defmodule Aptamer.Repo.Migrations.SwitchToTimezones do
  use Ecto.Migration

  def change do
    alter table(:files) do
      modify(:uploaded_on, :utc_datetime)
    end

    for table_name <- ~w/files jobs results predict_structure_options create_graph_options users/a do
      alter table(table_name) do
        modify(:inserted_at, :utc_datetime_usec)
        modify(:updated_at, :utc_datetime_usec)
      end
    end
  end
end
