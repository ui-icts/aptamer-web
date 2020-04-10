defmodule AptamerWeb.FileView do
  use AptamerWeb, :view
  use Phoenix.HTML

  import AptamerWeb.JobHelpers
  import AptamerWeb.InputHelpers

  def format_slider_value(%Ecto.Changeset{} = cs, field) do
    {_, fv} = Ecto.Changeset.fetch_field(cs, field)
    format_slider_value(field, fv)
  end

  def format_slider_value(field, value) do

    min_value = case field do
      :max_edit_distance -> 1
      :max_tree_distance -> 0
    end

    if value < min_value do
      "None"
    else
      to_string(value)
    end
  end

  def command_line_args(%Ecto.Changeset{} = cs) do
    struct = Ecto.Changeset.apply_changes(cs)
    struct.__struct__.args(struct) |> Enum.join(" ")
  end

  def version_label(%Ecto.Changeset{} = cs) do
    case Ecto.Changeset.apply_changes(cs) do
      %{tool_name: "vienna"} ->
        label do
          "Version: 2"
        end

      _ ->
        ""
    end
  end
end
