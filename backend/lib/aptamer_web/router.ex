defmodule AptamerWeb.Router do
  use AptamerWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AptamerWeb.LayoutView, :root}
    plug Aptamer.BrowserAuthPipeline
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", AptamerWeb do
    # Use the default browser stack
    pipe_through :browser
    resources "/files", FileController
    get "/results/:job_id", PageController, :download_results
    get "/download/:file_id", PageController, :download_file
    get "/login", SessionController, :new
    get "/logout", SessionController, :logout
    resources "/sessions", SessionController
    get "/health", HealthController, :index
    get "/", HomeController, :index
    # Public routes here
  end
end
