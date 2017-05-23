defmodule Aptamer.FileControllerTest do
  use Aptamer.ConnCase
  import Aptamer.Factory
  alias Aptamer.File

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "gets all the structure files", %{conn: conn} do
    insert(:file, %{file_purpose: "create-structure-input"})
    structure_file = insert(:file)

    conn = get conn, file_path(conn, :index, "structure")
    assert json_response(conn, 200)["data"] == [
      %{"id" => structure_file.id,
      "fileName" => structure_file.file_name,
      "filePurpose" => structure_file.file_purpose,
      "uploadedOn" => NaiveDateTime.to_iso8601(structure_file.uploaded_on)
      }
    ]
  end

  test "can upload new structure file", %{conn: conn} do
    upload = %Plug.Upload{path: "test/fixtures/Final_Rd12.fa", filename: "Final_Rd12.fa"}
    response =
      conn
      |> post( file_path(conn,:create,"structure"), %{ :file => upload} )
      |> json_response(200)

    assert %{
      "id" => id,
      "fileName" => "Final_Rd12.fa",
      "filePurpose" => "create-graph-input",
      "uploadedOn" => _
    } = response

    db_file = Repo.get(File, id)

    cs2 = checksum(%{path: "test/fixtures/Final_Rd12.fa"})
    cs1 = checksum(db_file)
    assert cs1 == cs2
  end

  def checksum(data) when is_nil(data), do: 0
  def checksum(%{path: path}) do
    Elixir.File.read!(path) |> checksum
  end

  def checksum(%Aptamer.File{data: data}), do: checksum(data)

  def checksum(data) do
    :crypto.hash(:sha256,data) |> Base.encode16 
  end
end
