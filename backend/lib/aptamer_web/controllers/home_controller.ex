defmodule AptamerWeb.HomeController do
  use AptamerWeb, :controller

  alias Aptamer.Repo
  alias Aptamer.Jobs

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      files = Jobs.list_files(current_user)
      render(conn, "index.html", user_files: files)
    else
      redirect(conn, to: "/sessions/new")
    end
  end
end
