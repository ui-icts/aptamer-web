defmodule AptamerWeb.PageControllerTest do
  use AptamerWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn) =~ "/sessions/new"
  end
end
