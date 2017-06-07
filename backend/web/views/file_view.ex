defmodule Aptamer.FileView do
  use Aptamer.Web, :view
  use JaSerializer.PhoenixView

  attributes [:file_name, :file_type, :uploaded_on]
  has_many :jobs, type: "jobs", serializer: Aptamer.JobView
  has_one :create_graph_options,
    type: "create-graph-options",
    serializer: Aptamer.CreateGraphOptionsView

end
