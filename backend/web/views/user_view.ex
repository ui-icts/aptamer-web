defmodule Aptamer.UserView do
  use Aptamer.Web, :view

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      name: user.name}
  end
end
