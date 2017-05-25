defmodule Aptamer.FileView do
  use Aptamer.Web, :view
  use JaSerializer.PhoenixView

  attributes [:file_name, :file_type, :uploaded_on]
  

end
