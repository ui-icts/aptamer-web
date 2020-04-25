defmodule AptamerWeb.FileController do
  use AptamerWeb, :controller

  alias Aptamer.Repo
  alias Aptamer.Jobs.File
  import Ecto.Query, only: [from: 2]

  plug :scrub_params, "data" when action in [:update]

  def create(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, file_data} = Elixir.File.read(params["file"].path)

    file_params = %{
      "file_name" => params["file"].filename,
      "uploaded_on" => DateTime.utc_now(),
      "file_type" => File.guess_file_type(file_data),
      "data" => file_data,
      "owner_id" => current_user.id,
			"sequence_count" => File.count_sequences(file_data)
    }

    {:ok, file} =
      %File{}
      |> File.changeset(file_params)
      |> Repo.insert()

    file = Repo.preload(file, :jobs)

    file_created(current_user, file)
    send_resp(conn, 200, "created: #{file.id}")
  end

  def show(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      query =
        from(file in File,
          where: file.id == ^id,
          left_join: jobs in assoc(file, :jobs),
          preload: [jobs: jobs]
        )

      file = Repo.one!(query)

      render(conn, "view.html", file: file)
    else
      redirect(conn, to: "/sessions/new")
    end

    #    render(conn, "show.json-api", data: file)
  end

  def delete(conn, %{"id" => id}) do
    file = Repo.get!(File, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.transaction(Aptamer.Jobs.delete_file(file))

    send_resp(conn, :no_content, "")
  end

  defp file_created(user, file) do
    Aptamer.Jobs.UserFiles.broadcast_file_uploaded(user, file)
  end
end
