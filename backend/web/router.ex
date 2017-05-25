defmodule Aptamer.Router do
  use Aptamer.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :accepts, ["json-api"]

    resources "/files", Aptamer.FileController
  end

  scope "/" do
    pipe_through :browser
    coherence_routes
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", Aptamer do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index

    #Public routes here
  end

  scope "/", Aptamer do
    pipe_through :protected
    #protected routes here
    get "/create-graph", CreateGraphController, :index
  end
  # Other scopes may use custom stacks.
  # scope "/api", Aptamer do
  #   pipe_through :api
  # end
end
