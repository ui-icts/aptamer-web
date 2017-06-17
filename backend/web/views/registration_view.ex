defmodule Aptamer.RegistrationView do
  use Aptamer.Web, :view

  def render("show.json", %{data: user}) do
    %{data: render_one(user, Aptamer.UserView, "user.json")}
  end

end
