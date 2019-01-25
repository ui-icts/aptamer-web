defmodule AptamerWeb.CreateGraphOptionsView do
  use AptamerWeb, :view
  use JaSerializer.PhoenixView

  attributes([:edge_type, :seed, :max_edit_distance, :max_tree_distance])

  has_one(:file,
    field: :file_id,
    type: "files"
  )
end
