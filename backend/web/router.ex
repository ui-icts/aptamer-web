defmodule Aptamer.Router do
  use Aptamer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["html"]
    plug :accepts, ["json"]
    plug :accepts, ["json-api"]

    resources "/files", Aptamer.FileController
    resources "/jobs", Aptamer.JobController
    resources "/create-graph-options", Aptamer.CreateGraphOptionsController
    resources "/predict-structure-options", Aptamer.PredictStructureOptionsController
    resources "/registration", Aptamer.RegistrationController, only: [:create]
  end

  scope "/" do
    pipe_through :browser
  end

  scope "/" do
    pipe_through :protected
  end

  scope "/", Aptamer do
    pipe_through :browser # Use the default browser stack
    get "/download/:file_id", PageController, :download_file
    get "/", PageController, :index
    #Public routes here
  end

  scope "/", Aptamer do
    pipe_through :protected
    #protected routes here
  end
end
