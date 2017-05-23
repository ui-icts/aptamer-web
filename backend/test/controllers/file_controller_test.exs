defmodule Aptamer.FileControllerTest do
  use Aptamer.ConnCase
  import Aptamer.Factory
  alias Aptamer.File

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "gets all the structure files", %{conn: conn} do
    fsa_file = insert(:file, %{file_purpose: "create-structure-input"})
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

end
