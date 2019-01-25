defmodule AptamerWeb.FileChannel do
  use Phoenix.Channel
  alias Porcelain.Process, as: Proc
  alias Aptamer.Repo
  alias Aptamer.Jobs.File

  def join("file:contents" <> file_id, _message, socket) do
    {:ok, "Joined the file contents channel", socket}
  end

  def handle_in("get_contents", %{"body" => body}, socket) do
    file_contents = Repo.get!(File, body).data

    {:reply, {:ok, %{body: file_contents}}, socket}
  end
end
