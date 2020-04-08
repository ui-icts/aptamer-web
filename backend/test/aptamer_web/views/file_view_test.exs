defmodule AptamerWeb.FileViewTest do
  use AptamerWeb.ConnCase, async: true
  alias AptamerWeb.FileView
  test "format_slider_value 0 as None" do
    assert FileView.format_slider_value(0) == "None"
  end


end
