defmodule AptamerWeb.JobView do
  use AptamerWeb, :view
  use JaSerializer.PhoenixView

  attributes([:status, :output, :inserted_at])

  has_one(:file,
    field: :file_id,
    type: "files"
  )
end
