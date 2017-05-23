defmodule Aptamer.CreateGraphController do
  use Aptamer.Web, :controller

  alias Aptamer.CreateGraph

  def index(conn, _params) do
    create_graph = Repo.all(CreateGraph)
    render(conn, "index.html", create_graph: create_graph)
  end

end
