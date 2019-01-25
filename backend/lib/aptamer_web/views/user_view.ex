defmodule AptamerWeb.UserView do
  use AptamerWeb, :view
  use JaSerializer.PhoenixView

  attributes([:email, :name])

  def render("show.json", %{data: user}) do
    %{data: render_one(user, AptamerWeb.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, name: user.name}
  end
end
