defmodule Aptamer.FileView do
  use Aptamer.Web, :view

  def render("index.json", %{files: files}) do
    %{files: render_many(files, Aptamer.FileView, "file.json")}
  end

  def render("show.json", %{file: file}) do
    %{file: render_one(file, Aptamer.FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    %{id: file.id,
      fileName: file.file_name,
      uploadedOn: file.uploaded_on,
      filePurpose: file.file_purpose}
  end
end
