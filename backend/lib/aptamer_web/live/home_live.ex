defmodule AptamerWeb.HomeLive do
  use Phoenix.LiveView
  alias Phoenix.View, as: PV

  alias Aptamer.{Auth, Jobs}

  def render(assigns) do
    PV.render(AptamerWeb.HomeView, "files.html", assigns)
  end

  @impl true
  def mount(%{current_user_id: current_user_id}, socket) do
    current_user = Auth.get_user(current_user_id)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(AptamerWeb.PubSub, "user:" <> current_user.id <> ":files")
    end

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

  def handle_info({:file_uploaded, file}, socket) do
    user_files = socket.assigns.user_files

    socket = assign(socket, :user_files, [file | user_files])
    {:noreply, socket}
  end

  def handle_info({:generated_file, file}, socket) do
    user_files = socket.assigns.user_files

    socket = assign(socket, :user_files, [file | user_files])
    {:noreply, socket}
  end

  def handle_event("delete_file", %{"file_id" => file_id}, socket) do
    file = Aptamer.Repo.get!(Aptamer.Jobs.File, file_id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Aptamer.Repo.transaction(Aptamer.Jobs.File.delete(file))

    user_files = socket.assigns.user_files
    socket = assign(socket, :user_files, Enum.reject(user_files, fn f -> f.id == file_id end))
    {:noreply, socket}
  end
end
