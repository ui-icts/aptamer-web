defmodule AptamerWeb.SecurityTest do
  use AptamerWeb.ConnCase

  import Aptamer.Factory

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    user = insert(:user)
    _files = insert_list(3, :file, owner: user)
    {:ok, conn: conn}
  end

  test "can't request resources when not logged in", %{conn: conn} do
    paths = [
      file_path(conn, :index),
      job_path(conn, :index)
    ]

    Enum.each(paths, fn p ->
      p_conn = get(conn, p)
      assert json_response(p_conn, 401)
    end)
  end
end
