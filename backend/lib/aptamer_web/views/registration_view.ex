defmodule AptamerWeb.RegistrationView do
  use AptamerWeb, :view

  def render("show.json", %{data: user}) do
    %{data: render_one(user, AptamerWeb.UserView, "user.json")}
  end
end
