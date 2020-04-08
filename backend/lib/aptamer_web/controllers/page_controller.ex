defmodule AptamerWeb.PageController do
  use AptamerWeb, :controller

  alias Aptamer.Repo
  alias Aptamer.Jobs.File, as: AptamerFile

  def index(conn, _params) do
    conn
    |> put_layout(false)
    |> render("index.html")
  end

  def send_file_contents(conn, file_name, file_content) do

    {:ok, temp_path} = Temp.mkdir("downloads")
    input_file = Path.join(temp_path, file_name)
    :ok = File.write(input_file, file_content)

    conn =
      conn
      |> put_resp_header("content-disposition", ~s(attachment; filename="#{file_name}"))
      |> send_file(200, input_file)

    conn
  end

  def download_results(conn, %{"job_id" => job_id}) do
    query =
      from result in Aptamer.Jobs.Result,
      where: result.job_id == ^job_id,
      preload: [job: :file]

    result = Repo.one!(query)
    file_name = "#{result.job.file.file_name}-results-#{String.slice(result.job.id, 0..7)}.zip"

    file_content = result.archive
    send_file_contents(conn, file_name, file_content)

  end

  def download_file(conn, %{"file_id" => file_id}) do
    file = Repo.get!(AptamerFile, file_id)
    {file_name, file_content} = {file.file_name, file.data}
    send_file_contents(conn, file_name, file_content)
  end

end
