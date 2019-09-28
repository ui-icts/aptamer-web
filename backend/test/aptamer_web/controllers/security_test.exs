defmodule AptamerWeb.SecurityTest do
  use AptamerWeb.ConnCase, async: true

  import Aptamer.Factory

  setup %{conn: conn} do
    conn = conn

    user = insert(:user)
    files = insert_list(3, :file, owner: user)

    {:ok, conn: conn, file_id: files |> List.first() |> Map.get(:id)}
  end

  test "can't request resources when not logged in", %{conn: conn, file_id: file_id} do
    paths = [
      file_path(conn, :show, file_id),
      "/"
    ]

    Enum.each(paths, fn p ->
      p_conn = get(conn, p)
      assert(redirected_to(p_conn, 302) =~ "/sessions/new", "Incorrect response for #{p}")
    end)
  end
end
