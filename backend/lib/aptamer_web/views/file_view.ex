defmodule AptamerWeb.FileView do
  use AptamerWeb, :view
  use JaSerializer.PhoenixView

  attributes [:file_name, :file_type, :uploaded_on]
  has_many :jobs, type: "jobs", serializer: AptamerWeb.JobView

end
