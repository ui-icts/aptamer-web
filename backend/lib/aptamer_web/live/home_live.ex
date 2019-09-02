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
        |> assign(:show_more, [])

      {:ok, socket}
    else

      {:ok, live_redirect(socket, to: "/sessions/new")}
    end

  end

  def handle_event("toggle_show_more", file_id, socket) do
    IO.puts "TOGGLE SHOW MORE"
    ids = socket.assigns.show_more
    new_ids = if file_id in ids do
      List.delete(ids, file_id)
    else
      [file_id | ids]
    end

    socket = assign(socket, :show_more, new_ids)
    {:noreply, socket}
  end

end
