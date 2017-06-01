defmodule Aptamer.FileController do
  use Aptamer.Web, :controller

  alias Aptamer.{File,Repo}
  alias JaSerializer.Params
  import Ecto.Query, only: [from: 2]
  
  plug JaSerializer.ContentTypeNegotiation when action in [:update]
  plug :scrub_params, "data" when action in [:update]

  def index(conn, params) do
    files = Repo.all(from f in Aptamer.File, preload: [jobs: :file])

    render(conn, "index.json-api", %{
      data: files,
      conn: conn,
      opts: [include: "jobs"]
    })
  end

  def create(conn, params) do
    
    {:ok, file_data} = Elixir.File.read(params["file"].path)

    file_params = %{
      "file_name" => params["file"].filename,
      "uploaded_on"=> DateTime.utc_now(),
      "file_type" => "structure",
      "data" => file_data
    }

    {:ok, file} =
      %File{}
      |> File.changeset(file_params)
      |> Repo.insert

    file = Repo.preload(file, :jobs)
    render(conn, "show.json-api", data: file)
  end

  def show(conn, %{"id" => id}) do
    file = Repo.get!(File, id) |> Repo.preload :jobs
    render(conn, "show.json-api", data: file)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "files", "attributes" => _file_params}}) do
    file = Repo.get!(File, id)
    changeset = File.changeset(file, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, file} ->
        file = Repo.preload(file, :jobs)
        render(conn, "show.json-api", data: file)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Repo.get!(File, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(file)

    send_resp(conn, :no_content, "")
  end
  # def create(conn, %{"file" => file_params}) do
  #   changeset = File.changeset(%File{}, file_params)
  #
  #   case Repo.insert(changeset) do
  #     {:ok, file} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", file_path(conn, :show, file))
  #       |> render("show.json", file: file)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(Aptamer.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   file = Repo.get!(File, id)
  #   render(conn, "show.json", file: file)
  # end
  #
  # def update(conn, %{"id" => id, "file" => file_params}) do
  #   file = Repo.get!(File, id)
  #   changeset = File.changeset(file, file_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, file} ->
  #       render(conn, "show.json", file: file)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(Aptamer.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   file = Repo.get!(File, id)
  #
  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(file)
  #
  #   send_resp(conn, :no_content, "")
  # end
end
