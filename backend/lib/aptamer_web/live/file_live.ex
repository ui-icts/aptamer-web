defmodule AptamerWeb.FileLive do
  use AptamerWeb, :live_view
  alias Aptamer.Jobs.JobStatus
  require Logger

  import AptamerWeb.FileView
  @impl true
  def mount(_params, %{"file_id" => file_id}, socket) do
    file = Aptamer.Jobs.view_file(file_id)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(AptamerWeb.PubSub, JobStatus.topic(file))
    end

    graph_options =
      Aptamer.Jobs.CreateGraphOptions.default()
      |> Aptamer.Jobs.CreateGraphOptions.changeset()

    predict_options =
      Aptamer.Jobs.PredictStructureOptions.default()
      |> Aptamer.Jobs.PredictStructureOptions.changeset()

    socket =
      socket
      |> assign(:file, file)
      |> assign(:show_more, false)
      |> assign(:show_help, false)
      |> assign(:show_command_preview, true)
      |> assign(:error_message, false)
      |> assign(:confirm_delete, false)
      |> assign(:options_form, options_by_file_type(file.file_type))
      |> assign(:predict_structure_options, predict_options)
      |> assign(:create_graph_options, graph_options)

    {:ok, socket}
  end

  defp options_by_file_type(file_type) do
    case file_type do
      "structure" -> "create_graph"
      "fasta" -> "predict_structures"
    end
  end

  @impl true
  def handle_event("toggle_show_more", _file_id, socket) do
    show_more = !socket.assigns.show_more

    socket = assign(socket, :show_more, show_more)
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_show_help", _file_id, socket) do
    show_help = !socket.assigns.show_help

    socket = assign(socket, :show_help, show_help)
    {:noreply, socket}
  end

  @impl true
  def handle_event("show_options", %{"form_options" => %{"choice" => choice}}, socket) do
    socket = assign(socket, :options_form, choice)
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_graph_options", %{"create_graph_options" => params}, socket) do
    options = Aptamer.Jobs.CreateGraphOptions.default()
    cs = Aptamer.Jobs.CreateGraphOptions.changeset(options, params)

    socket =
      socket
      |> assign(:create_graph_options, cs)
      |> assign(:error_message, false)

    {:noreply, socket}
  end

  @impl true
  def handle_event("update_predict_options", %{"predict_structure_options" => params}, socket) do
    options = Aptamer.Jobs.PredictStructureOptions.default()
    cs = Aptamer.Jobs.PredictStructureOptions.changeset(options, params)

    socket =
      socket
      |> assign(:predict_structure_options, cs)
      |> assign(:error_message, false)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "create_job",
        options_parms,
        socket
      ) do
    file = socket.assigns.file

    case Aptamer.Jobs.create_new_job(file, options_parms) do
      {:ok, file, job} ->
        Logger.info "Bypassing start job waiting for schedule"
        # if Application.get_env(:aptamer, :start_jobs) == true do
        #   Task.start(fn ->
        #     Aptamer.Jobs.Processor.execute(job)
        #   end)
        # end

        socket = assign(socket, :file, file)
        {:noreply, socket}

      {:invalid, which_options, options_changeset} ->
        IO.inspect(options_changeset)

        socket =
          socket
          |> assign(which_options, options_changeset)
          |> assign(:error_message, "Invalid options for script")

        {:noreply, socket}

      {:error, error_message, which_options, options_changeset} ->
        socket =
          socket
          |> assign(which_options, options_changeset)
          |> assign(:error_message, error_message)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("dismiss_generic_error", _naddaa, socket) do
    {:noreply, socket |> assign(:error_message, false)}
  end

  @impl true
  def handle_info({:status_change, job_id, new_status}, socket) do
    file = socket.assigns.file
    jobs = file.jobs
    job_idx = Enum.find_index(jobs, &(&1.id == job_id))
    updated_jobs = List.update_at(jobs, job_idx, fn struct -> %{struct | status: new_status} end)
    socket = assign(socket, :file, %{file | jobs: updated_jobs})
    {:noreply, socket}
  end
end
