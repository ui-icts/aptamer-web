defmodule Aptamer.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Ecto.Multi
  alias Aptamer.Repo

  alias Aptamer.Jobs.{File, Job, CreateGraphOptions, PredictStructureOptions, JobStatus}

  require Logger

  def list_files(current_user) do
    query =
      from(file in File,
        left_join: jobs in assoc(file, :jobs),
        where: file.owner_id == ^current_user.id,
        order_by: :uploaded_on,
        preload: [jobs: jobs]
      )

    Repo.all(query)
  end

  def view_file(file_id) do
    query =
      from(file in File,
        left_join: jobs in assoc(file, :jobs),
        preload: [jobs: jobs]
      )

    Repo.get(query, file_id)
  end

  def create_new_job(file, options_params) do
    # 2nd arg wins here, even if id, file_id, or status
    # are in the params they wouldn't be picked...that is on
    # purpose. that way a file couldn't be spoofed.

    params =
      Map.merge(options_params, %{
        "id" => Ecto.UUID.generate(),
        "file_id" => file.id,
        "status" => "ready"
      })

    {which_options, cs} =
      %Job{}
      |> cast(params, [:id, :file_id, :status])
      |> cast_assoc(:create_graph_options)
      |> cast_assoc(:predict_structure_options)
      |> Job.validate_only_one_options()

    # |> cast_assoc(:predict_structure_options)

    if cs.valid? do
      try do
        case Repo.insert(cs) do
          {:ok, job} ->
            file = Repo.preload(file, :jobs, force: true)
            {:ok, file, job}

          {:error, cs} ->
            {:ok, options_changes} = Ecto.Changeset.fetch_change(cs, which_options)
            {:error, "Unable to start job", which_options, options_changes}
        end
      rescue
        error in [Postgrex.Error] ->
          Logger.error("Unable to save job")
          Logger.error(Exception.format(:error, error, __STACKTRACE__))

          {:ok, options_changes} = Ecto.Changeset.fetch_change(cs, which_options)
          {:error, "Error creating job", which_options, options_changes}
      end
    else
      {:ok, options_changes} = Ecto.Changeset.fetch_change(cs, which_options)
      {:invalid, which_options, options_changes}
    end
  end

  def change_status(job, new_status) do
    cs = Job.changeset(job, %{status: to_string(new_status)})
    {:ok, job} = Repo.update(cs)
    JobStatus.broadcast(job)
    job
  end
  def next_ready() do
    query = from(j in Job, where: j.status == "ready")

    query
    |> first(:inserted_at)
    |> Repo.one()
  end

  def ready_batch(amount \\ 100) do
    query =
      from(j in Job,
        where: j.status == "ready",
        order_by: :inserted_at,
        limit: ^amount
      )

    query
    |> Repo.all()
  end

  def load_associations(job) do
    job
    |> Repo.preload(:create_graph_options)
    |> Repo.preload(:predict_structure_options)
    |> Repo.preload(:file)
  end

  def delete_file(file) do
    jobs = Repo.all(Ecto.assoc(file, :jobs))

    Multi.new()
    |> delete_jobs(jobs, file)
    |> Multi.delete(:file, file)
  end

  def delete_job(job) do
    job = load_associations(job)
    delete_jobs(Multi.new(), [job], job.file)
  end

  def delete_jobs(multi, jobs, _) when jobs == [] do
    multi
  end

  def delete_jobs(multi, jobs, file) do
    create_graph_ids = unique_id_list(jobs, :create_graph_options_id)
    predict_structure_ids = unique_id_list(jobs, :predict_structure_options_id)

    create_graph_query = from(cgo in CreateGraphOptions, where: cgo.id in ^create_graph_ids)

    predict_structure_query =
      from(pso in PredictStructureOptions, where: pso.id in ^predict_structure_ids)

    multi
    |> Multi.delete_all(:results, Ecto.assoc(jobs, :results))
    |> Multi.delete_all(:jobs, Ecto.assoc(file, :jobs))
    |> Multi.delete_all(:create_graph_options, create_graph_query)
    |> Multi.delete_all(:predict_structure_options, predict_structure_query)
  end

  def unique_id_list(structList, id_name) do
    Enum.map(structList, fn struct -> Map.get(struct, id_name) end)
    |> Enum.filter(fn id -> id != nil end)
    |> Enum.uniq()
  end
end
