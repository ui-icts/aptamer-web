defmodule AptamerWeb.FileControllerTest do
  use AptamerWeb.ConnCase, async: true
  import Aptamer.Factory
  alias Aptamer.Jobs.File

  setup %{conn: conn} do
    current_user = insert(:user)

    conn =
      conn
      |> guardian_login(current_user)

    {:ok, conn: conn, current_user: current_user}
  end

  test "can upload new structure file", %{conn: conn, current_user: current_user} do
    upload = %Plug.Upload{path: "test/fixtures/Final_Rd12.fa", filename: "Final_Rd12.fa"}

    conn =
      conn
      |> post(file_path(conn, :create), %{:file => upload})

    assert "created: " <> id = response(conn, 200)

    db_file = Repo.get(File, id)

    cs2 = checksum(%{path: "test/fixtures/Final_Rd12.fa"})
    cs1 = checksum(db_file)
    assert cs1 == cs2

    db_file = Repo.preload(db_file, :owner)
    assert db_file.owner == current_user
  end

  test "shows chosen resource", %{conn: conn} do
    file = insert(:file, file_type: "structure")
    conn = get(conn, file_path(conn, :show, file))
    assert html_response(conn, 200)
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get(conn, file_path(conn, :show, "11111111-1111-1111-1111-111111111111"))
    end
  end

  test "deletes file without associations", %{conn: conn} do
    file = Repo.insert!(%File{})
    conn = delete(conn, file_path(conn, :delete, file))
    assert response(conn, 204)
    refute Repo.get(File, file.id)
  end

  def checksum(data) when is_nil(data), do: 0

  def checksum(%{path: path}) do
    Elixir.File.read!(path) |> checksum
  end

  def checksum(%Aptamer.Jobs.File{data: data}), do: checksum(data)

  def checksum(data) do
    :crypto.hash(:sha256, data) |> Base.encode16()
  end
end
