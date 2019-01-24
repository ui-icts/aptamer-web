defmodule AptamerWeb.PredictStructureOptionsView do
  use AptamerWeb, :view
  use JaSerializer.PhoenixView

  attributes [:run_mfold, :vienna_version, :prefix, :suffix, :pass_options, :inserted_at, :updated_at]
  
  has_one :file,
    field: :file_id,
    type: "files"

end
