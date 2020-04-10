defmodule AptamerWeb.FileViewTest do
  use AptamerWeb.ConnCase, async: true
  alias AptamerWeb.FileView
  test "format_slider_value 0 as None" do
    assert FileView.format_slider_value(:max_edit_distance, 0) == "None"
    assert FileView.format_slider_value(:max_tree_distance, 0) == "0"
    assert FileView.format_slider_value(:max_tree_distance, -1) == "None"
  end


end
