defmodule Aptamer.PageController do
  use Aptamer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
