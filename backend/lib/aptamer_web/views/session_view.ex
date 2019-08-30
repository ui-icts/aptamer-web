defmodule AptamerWeb.SessionView do
  use AptamerWeb, :view
  import AptamerWeb.InputHelpers

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, AptamerWeb.SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, AptamerWeb.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id}
  end

end
