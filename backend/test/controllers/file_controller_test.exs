defmodule Aptamer.FileControllerTest do
  use Aptamer.ConnCase
  import Aptamer.Factory
  alias Aptamer.File

  setup %{conn: conn} do

    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "gets all the structure files", %{conn: conn} do

    fasta_file = insert(:file, %{file_type: "fasta"})
    structure_file = insert(:file, file_type: "structure")

    conn = get conn, file_path(conn, :index)
    assert json_response(conn, 200)["data"] == [
      %{"id" => fasta_file.id,
        "type" => "files",
        "attributes" => %{
          "file-name" => fasta_file.file_name,
          "file-type" => fasta_file.file_type,
          "uploaded-on" => NaiveDateTime.to_iso8601(fasta_file.uploaded_on)
        }
      },
      %{"id" => structure_file.id,
        "type" => "files",
        "attributes" => %{
          "file-name" => structure_file.file_name,
          "file-type" => structure_file.file_type,
          "uploaded-on" => NaiveDateTime.to_iso8601(structure_file.uploaded_on)
        }
      }
    ]
  end

  test "can upload new structure file", %{conn: conn} do
    upload = %Plug.Upload{path: "test/fixtures/Final_Rd12.fa", filename: "Final_Rd12.fa"}
    response =
      conn
      |> post( file_path(conn,:create), %{ :file => upload} )
      |> json_response(200)

    assert %{
      "id" => id,
      "type" => "files",
      "attributes" => %{
        "file-name" => "Final_Rd12.fa",
        "file-type" => "structure",
        "uploaded-on" => _
      }
    } = response["data"]

    db_file = Repo.get(File, id)

    cs2 = checksum(%{path: "test/fixtures/Final_Rd12.fa"})
    cs1 = checksum(db_file)
    assert cs1 == cs2
  end

  test "shows chosen resource", %{conn: conn} do
    file = insert(:file, file_type: "structure")
    conn = get conn, file_path(conn, :show, file)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{file.id}"
    assert data["type"] == "files"
    assert data["attributes"]["file-name"] == file.file_name
    assert data["attributes"]["file-type"] == file.file_type
    assert data["attributes"]["uploaded-on"] == NaiveDateTime.to_iso8601(file.uploaded_on)
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, file_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    
    file = insert(:file, file_type: "structure")
    change_attrs = %{file | file_type: "fasta"}

    # If I don't do this loopdi loop then the data gets
    # passed to the controller as multipart and I'm not
    # testing my JSONA-API stuff....evidenced because
    # for a while my test was passing but my code was
    # not working from Ember
    post_params =
      Aptamer.FileView
      |> JaSerializer.format(change_attrs, conn)
      |> Poison.encode!

    conn = put conn, file_path(conn, :update, file), post_params

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get(File, file.id).file_type == "fasta"
  end

  test "deletes chosen resource", %{conn: conn} do
    file = Repo.insert! %File{}
    conn = delete conn, file_path(conn, :delete, file)
    assert response(conn, 204)
    refute Repo.get(File, file.id)
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
