defmodule AptamerWeb.FileLive do
  use Phoenix.LiveView
  alias Phoenix.View, as: PV

  def render(assigns) do
    PV.render(AptamerWeb.FileView, "show.html", assigns)
  end

  @impl true
  def mount(%{file_id: file_id}, socket) do

    IO.inspect(file_id)
    file = Aptamer.Jobs.view_file(file_id)

    graph_options =
      Aptamer.Jobs.CreateGraphOptions.default()
      |> Aptamer.Jobs.CreateGraphOptions.changeset()

    socket =
      socket
      |> assign(:file, file)
      |> assign(:show_more, false)
      |> assign(:show_help, false)
      |> assign(:show_command_preview, true)
      |> assign(:confirm_delete, false)
      |> assign(:options_form, options_by_file_type(file.file_type))
      |> assign(:predict_structure_options, Aptamer.Jobs.PredictStructureOptions.default())
      |> assign(:create_graph_options, graph_options)

    {:ok, socket}
  end

  defp options_by_file_type(file_type) do
    case file_type do
      "structure" -> "create_graph"
      "fasta" -> "predict_structures"
    end
  end

  def handle_event("toggle_show_more", file_id, socket) do
    show_more = !socket.assigns.show_more

    socket = assign(socket, :show_more, show_more)
    {:noreply, socket}
  end

  def handle_event("toggle_show_help", file_id, socket) do
    show_help = !socket.assigns.show_help

    socket = assign(socket, :show_help, show_help)
    {:noreply, socket}
  end

  def handle_event("show_options", %{"form_options_choice" => choice}, socket) do
    IO.puts "CHOICE: #{choice}"
    socket = assign(socket, :options_form, choice)
    {:noreply, socket}
  end

  def handle_event("update_graph_options", %{"create_graph_options" => params}, socket) do
    IO.inspect params
    options = Aptamer.Jobs.CreateGraphOptions.default()
    cs = Aptamer.Jobs.CreateGraphOptions.changeset(options, params)
    socket = assign(socket, :create_graph_options, cs)
    {:noreply, socket}
  end

end
