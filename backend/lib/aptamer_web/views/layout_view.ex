defmodule AptamerWeb.LayoutView do
  use AptamerWeb, :view

  def is_authenticated?(conn) do
    Aptamer.Guardian.Plug.authenticated?(conn)
  end

  def current_user_name(conn) do
    user = Aptamer.Guardian.Plug.current_resource(conn)
    if user do
      user.name
    else
      nil
    end
  end
end
