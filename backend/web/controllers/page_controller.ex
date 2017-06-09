defmodule Aptamer.PageController do
  use Aptamer.Web, :controller

  alias Aptamer.Repo
  alias Aptamer.File, as: AptamerFile

  def index(conn, _params) do
    render conn, "index.html"
  end

  def download_file(conn, %{"file_id" => file_id}) do
    file = Repo.get!(AptamerFile, file_id)

    {:ok, temp_path} = Temp.mkdir "downloads"
    input_file = Path.join(temp_path, file.file_name)
    File.write input_file, file.data

    conn
    |> put_resp_header("content-disposition", ~s(attachment; filename="#{file.file_name}"))
    |> send_file(200, input_file)

    File.rm input_file


  end
end
