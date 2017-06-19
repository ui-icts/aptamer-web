defmodule Aptamer.SessionView do
  use Aptamer.Web, :view

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, Aptamer.SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, Aptamer.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id}
  end
end
