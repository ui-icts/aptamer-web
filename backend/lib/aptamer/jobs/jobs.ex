defmodule Aptamer.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Aptamer.Repo

  alias Aptamer.Jobs.File

  def list_files(current_user) do

    query =
      from(file in File,
        left_join: jobs in assoc(file, :jobs),
        where: file.owner_id == ^current_user.id,
        order_by: :uploaded_on,
        preload: [jobs: jobs]
      )

    files = Repo.all(query)
  end

  def view_file(file_id) do
    query =
      from(file in File,
        left_join: jobs in assoc(file, :jobs),
        preload: [jobs: jobs]
      )

    Repo.get(query, file_id)
  end
end
