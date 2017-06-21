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

  pipeline :api_auth do
    plug :accepts, ["html","json","json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/" do
    pipe_through :browser
  end

  scope "/", Aptamer do
    pipe_through :api
    #protected routes here
    resources "/register", RegistrationController, only: [:create]

    post "/token", SessionController, :create, as: :login
  end

  scope "/", Aptamer do
    pipe_through :api_auth
    resources "/files", FileController
    resources "/jobs", JobController
    resources "/create-graph-options", CreateGraphOptionsController
    resources "/predict-structure-options", PredictStructureOptionsController
    get "/users/me", SessionController, :show
  end

  scope "/", Aptamer do
    pipe_through :browser # Use the default browser stack
    get "/download/:file_id", PageController, :download_file
    get "/", PageController, :index
    #Public routes here
  end

end
