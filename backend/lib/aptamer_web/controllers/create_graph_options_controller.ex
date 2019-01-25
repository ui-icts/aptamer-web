defmodule AptamerWeb.CreateGraphOptionsController do
  use AptamerWeb, :controller

  alias Aptamer.Jobs.CreateGraphOptions
  alias JaSerializer.Params

  plug JaSerializer.ContentTypeNegotiation when action in [:create, :update]
  plug :accepts, ["json-api"]
  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, params) do
    create_graph_options =
      case params do
        %{"filter" => %{"forFile" => file_id}} ->
          query =
            from(j in Aptamer.Jobs.Job,
              where: j.file_id == ^file_id and not is_nil(j.create_graph_options_id),
              order_by: [desc: j.inserted_at]
            )

          job = query |> first |> preload(:create_graph_options) |> Repo.one()

          if is_nil(job) do
            []
          else
            [job.create_graph_options]
          end

        _ ->
          Repo.all(CreateGraphOptions)
      end

    render(conn, "index.json-api", data: create_graph_options)
  end

  def create(conn, %{
        "data" =>
          data = %{"type" => "create-graph-options", "attributes" => _create_graph_options_params}
      }) do
    changeset = CreateGraphOptions.changeset(%CreateGraphOptions{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, create_graph_options} ->
        conn
        |> put_status(:created)
        |> put_resp_header(
          "location",
          Routes.create_graph_options_path(conn, :show, create_graph_options)
        )
        |> render("show.json-api", data: create_graph_options)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    create_graph_options = Repo.get!(CreateGraphOptions, id)
    render(conn, "show.json-api", data: create_graph_options)
  end

  def update(conn, %{
        "id" => id,
        "data" =>
          data = %{"type" => "create-graph-options", "attributes" => _create_graph_options_params}
      }) do
    create_graph_options = Repo.get!(CreateGraphOptions, id)
    changeset = CreateGraphOptions.changeset(create_graph_options, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, create_graph_options} ->
        render(conn, "show.json-api", data: create_graph_options)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    create_graph_options = Repo.get!(CreateGraphOptions, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(create_graph_options)

    send_resp(conn, :no_content, "")
  end
end
