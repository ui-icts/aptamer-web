defmodule AptamerWeb.PageControllerTest do
  use AptamerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Aptamer"
  end
end
