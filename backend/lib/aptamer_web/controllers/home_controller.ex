defmodule AptamerWeb.HomeController do
  use AptamerWeb, :controller

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      render(conn, :index, current_user_id: current_user.id)
    else
      redirect(conn, to: "/sessions/new")
    end
  end
end
