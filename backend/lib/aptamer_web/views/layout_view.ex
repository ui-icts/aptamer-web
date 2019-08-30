defmodule AptamerWeb.LayoutView do
  use AptamerWeb, :view

  def is_authenticated?(conn) do
    false
  end

  def current_user_name(conn) do
    nil
  end
end
