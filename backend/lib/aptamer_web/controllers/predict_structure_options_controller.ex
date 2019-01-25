defmodule AptamerWeb.PredictStructureOptionsController do
  use AptamerWeb, :controller

  alias Aptamer.PredictStructureOptions
  alias JaSerializer.Params

  plug JaSerializer.ContentTypeNegotiation when action in [:create,:update]
  plug :accepts, ["json-api"]
  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, params) do
    predict_structure_options = case params do

      %{"filter" => %{"forFile" => file_id}} ->
        query = from j in Aptamer.Job,
                  where: j.file_id == ^file_id and not is_nil(j.predict_structure_options_id),
                  order_by: [desc: j.inserted_at]

        job = query |> first |> preload(:predict_structure_options) |> Repo.one

        if is_nil(job) do
          []
        else
          [job.predict_structure_options]
        end

      _ -> Repo.all(PredictStructureOptions)
    end

    render(conn, "index.json-api", data: predict_structure_options)
  end

  def create(conn, %{"data" => data = %{"type" => "predict-structure-options", "attributes" => _predict_structure_options_params}}) do
    changeset = PredictStructureOptions.changeset(%PredictStructureOptions{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, predict_structure_options} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.predict_structure_options_path(conn, :show, predict_structure_options))
        |> render("show.json-api", data: predict_structure_options)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    predict_structure_options = Repo.get!(PredictStructureOptions, id)
    render(conn, "show.json-api", data: predict_structure_options)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "predict-structure-options", "attributes" => _predict_structure_options_params}}) do
    predict_structure_options = Repo.get!(PredictStructureOptions, id)
    changeset = PredictStructureOptions.changeset(predict_structure_options, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, predict_structure_options} ->
        render(conn, "show.json-api", data: predict_structure_options)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    predict_structure_options = Repo.get!(PredictStructureOptions, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(predict_structure_options)

    send_resp(conn, :no_content, "")
  end

end
