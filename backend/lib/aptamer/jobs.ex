defmodule Aptamer.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Aptamer.Repo

  alias Aptamer.Jobs.{File,Job}

  def next_ready() do
    query = from j in Job, where: j.status == "ready"

    query
    |> first(:inserted_at)
    |> Repo.one
  end

  def load_associations(job) do
    job
    |> Repo.preload(:create_graph_options)
    |> Repo.preload(:predict_structure_options)
    |> Repo.preload(:file)
  end
end
