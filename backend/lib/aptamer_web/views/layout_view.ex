defmodule AptamerWeb.LayoutView do
  use AptamerWeb, :view

  def is_authenticated?(_conn) do
    false
  end

  def current_user_name(_conn) do
    nil
  end
end
