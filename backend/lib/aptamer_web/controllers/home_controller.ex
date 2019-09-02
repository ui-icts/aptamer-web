defmodule AptamerWeb.HomeController do
  use AptamerWeb, :controller

  alias Aptamer.Repo
  alias Aptamer.Jobs

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      live_render(conn, AptamerWeb.HomeLive, session: %{
        current_user_id: current_user.id
      })
    else
      redirect(conn, to: "/sessions/new")
    end
  end
end
