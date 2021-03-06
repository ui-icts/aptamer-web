defmodule AptamerWeb.JobController do
  use AptamerWeb, :controller

  alias Aptamer.Jobs.Job
  alias JaSerializer.Params

  plug JaSerializer.ContentTypeNegotiation when action in [:create, :update]
  plug :accepts, ["json-api"]
  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    jobs = Repo.all(Job)
    render(conn, "index.json-api", data: jobs)
  end

  def create(conn, %{"data" => data = %{"type" => "jobs", "attributes" => _job_params}}) do
    changeset = Job.changeset(%Job{}, Params.to_attributes(data))
    changeset = Ecto.Changeset.cast(changeset, data, [:id])

    case Repo.insert(changeset) do
      {:ok, job} ->
        job =
          job
          |> Repo.preload(:create_graph_options)
          |> Repo.preload(:predict_structure_options)
          |> Repo.preload(:file)

        if Application.get_env(:aptamer, :start_jobs) == true do
          Aptamer.JobControl.start_job(job)
        end

        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.job_path(conn, :show, job))
        |> render("show.json-api", data: job)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Repo.get!(Job, id)
    render(conn, "show.json-api", data: job)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "jobs", "attributes" => _job_params}
      }) do
    job = Repo.get!(Job, id)
    changeset_params = Params.to_attributes(data)
    changeset = Job.changeset(job, changeset_params)

    case Repo.update(changeset) do
      {:ok, job} ->
        render(conn, "show.json-api", data: job)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Repo.get!(Job, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(job)

    send_resp(conn, :no_content, "")
  end
end
