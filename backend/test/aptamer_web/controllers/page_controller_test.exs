defmodule AptamerWeb.PageControllerTest do
  use AptamerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn) =~ "/sessions/new"
  end
end
