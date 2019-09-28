defmodule AptamerWeb.FileView do
  use AptamerWeb, :view

  import AptamerWeb.JobHelpers

  def format_slider_value(%Ecto.Changeset{} = cs, field) do
    {_, fv} = Ecto.Changeset.fetch_field(cs, field)
    format_slider_value(fv)
  end

  def format_slider_value(edit_distance) do
    if edit_distance >= 11 do
      "None"
    else
      to_string(edit_distance)
    end
  end

  def command_line_args(%Ecto.Changeset{} = cs) do
    struct = Ecto.Changeset.apply_changes(cs)
    struct.__struct__.args(struct) |> Enum.join(" ")
  end
end
