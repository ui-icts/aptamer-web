defmodule AptamerWeb.Router do
  use AptamerWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug Aptamer.BrowserAuthPipeline
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["html", "json", "json-api"]
  end

  pipeline :api_auth do
    plug :accepts, ["html", "json", "json-api"]
    plug Aptamer.AuthAccessPipeline
  end

  scope "/", AptamerWeb do
    pipe_through :api
    # protected routes here
    resources "/register", RegistrationController, only: [:create]
    post "/token", SessionController, :create, as: :login
  end

  scope "/", AptamerWeb do
    pipe_through :api_auth
    resources "/jobs", JobController
    resources "/create-graph-options", CreateGraphOptionsController
    resources "/predict-structure-options", PredictStructureOptionsController
    get "/users/me", SessionController, :show
  end

  scope "/", AptamerWeb do
    # Use the default browser stack
    pipe_through :browser
    resources "/files", FileController
    get "/results/:job_id", PageController, :download_file
    get "/download/:file_id", PageController, :download_file
    get "/spa", PageController, :index
    resources "/sessions", SessionController
    get "/", HomeController, :index
    # Public routes here
  end
end
