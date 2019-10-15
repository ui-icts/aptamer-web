defmodule AptamerWeb.PageController do
  use AptamerWeb, :controller

  alias Aptamer.Repo
  alias Aptamer.Jobs.File, as: AptamerFile

  def index(conn, _params) do
    conn
    |> put_layout(false)
    |> render("index.html")
  end

  def download_file(conn, params) do
    {file_name, file_content} =
      case params do
        %{"file_id" => file_id} ->
          file = Repo.get!(AptamerFile, file_id)
          {file.file_name, file.data}

        %{"job_id" => job_id} ->
          query =
            from result in Aptamer.Jobs.Result,
          where: result.job_id == ^job_id,
          preload: [job: :file]

          result = Repo.one!(query)
          file_name = "#{result.job.file.file_name}-results-#{String.slice(result.job.id, 0..7)}.zip"
          {file_name, result.archive}
      end

    {:ok, temp_path} = Temp.mkdir("downloads")
    input_file = Path.join(temp_path, file_name)
    File.write(input_file, file_content)

    conn =
      conn
      |> put_resp_header("content-disposition", ~s(attachment; filename="#{file_name}"))
      |> send_file(200, input_file)

    conn
  end
end
