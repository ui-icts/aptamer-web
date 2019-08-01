defmodule AptamerWeb.CreateGraphOptionsView do
  use AptamerWeb, :view
  use JaSerializer.PhoenixView

  import Kernel, except: [spawn: 1]
  attributes([:edge_type, :seed, :max_edit_distance, :max_tree_distance, :batch_size, :spawn])

  has_one(:file,
    field: :file_id,
    type: "files"
  )
end
