defmodule Aptamer.Router do
  use Aptamer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["html","json","json-api"]

  end

  scope "/" do
    pipe_through :browser
  end

  scope "/", Aptamer do
    pipe_through :api
    #protected routes here
    resources "/files", FileController
    resources "/jobs", JobController
    resources "/create-graph-options", CreateGraphOptionsController
    resources "/predict-structure-options", PredictStructureOptionsController
    resources "/register", RegistrationController, only: [:create]

    post "/token", SessionController, :create, as: :login
  end

  scope "/", Aptamer do
    pipe_through :browser # Use the default browser stack
    get "/download/:file_id", PageController, :download_file
    get "/", PageController, :index
    #Public routes here
  end

end
