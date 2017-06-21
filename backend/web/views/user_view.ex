defmodule Aptamer.UserView do
  use Aptamer.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email, :name]

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Aptamer.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      name: user.name}
  end

end
