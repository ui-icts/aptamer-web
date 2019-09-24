defmodule AptamerWeb.FileController do
  use AptamerWeb, :controller

  alias Aptamer.Repo
  alias Aptamer.Jobs.File
  alias Aptamer.Jobs
  alias JaSerializer.Params
  import Ecto.Query, only: [from: 2]

  plug JaSerializer.ContentTypeNegotiation when action in [:update]
  plug :scrub_params, "data" when action in [:update]

  def index(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)

    files = Jobs.list_files(current_user)

    json(conn,Enum.map(files, fn f ->
      Map.from_struct(f) |> Map.take([:id,:file_name])
    end))
  end

  def create(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, file_data} = Elixir.File.read(params["file"].path)

    file_params = %{
      "file_name" => params["file"].filename,
      "uploaded_on" => DateTime.utc_now(),
      "file_type" => "structure",
      "data" => file_data,
      "owner_id" => current_user.id
    }

    {:ok, file} =
      %File{}
      |> File.changeset(file_params)
      |> Repo.insert()

    file = Repo.preload(file, :jobs)

    file_created(current_user, file)
    send_resp(conn, 200, "created")
  end

  def show(conn, %{"id" => id}) do
    query =
      from(file in File,
        where: file.id == ^id,
        left_join: jobs in assoc(file, :jobs),
        preload: [jobs: jobs]
      )

    file = Repo.one!(query)

    render(conn, "view.html", file: file)
#    render(conn, "show.json-api", data: file)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "files", "attributes" => _file_params}
      }) do
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
    Repo.transaction(File.delete(file))

    send_resp(conn, :no_content, "")
  end

  defp file_created(user,file) do
    Phoenix.PubSub.broadcast(AptamerWeb.PubSub, "user:" <> user.id <> ":files", {:file_uploaded, file})
  end
end
