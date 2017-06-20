defmodule Aptamer.ErrorView do
  use Aptamer.Web, :view
  use JaSerializer.PhoenixView

  def render("401.json", _assigns) do
    %{title: "Unauthorized", code: 401}
    |> JaSerializer.ErrorSerializer.format
  end

  def render("403.json", _assigns) do
    %{title: "forbidden", code: 403}
    |> JaSerializer.ErrorSerializer.format
  end

  def render("500.json", _assigns) do
    %{title: "Internal Server Error", code: 500}
    |> JaSerializer.ErrorSerializer.format
  end
  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
