defmodule Aptamer.CreateGraphOptionsView do
  use Aptamer.Web, :view
  use JaSerializer.PhoenixView

  attributes [:edge_type, :seed, :max_edit_distance, :max_tree_distance, :inserted_at, :updated_at]
  
  has_one :file,
    field: :file_id,
    type: "files"
end
