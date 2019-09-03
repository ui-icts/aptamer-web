defmodule AptamerWeb.HomeLive do
  use Phoenix.LiveView
  alias Phoenix.View, as: PV

  alias Aptamer.{Auth,Jobs}

  def render(assigns) do
    PV.render(AptamerWeb.HomeView, "index.html", assigns)
  end

  @impl true
  def mount(%{current_user_id: current_user_id}, socket) do

    current_user = Auth.get_user(current_user_id)

    if current_user do
      files = Jobs.list_files(current_user)

      socket =
        socket
        |> assign(:user_files, files)

      {:ok, socket}
    else

      {:ok, live_redirect(socket, to: "/sessions/new")}
    end

  end

end
