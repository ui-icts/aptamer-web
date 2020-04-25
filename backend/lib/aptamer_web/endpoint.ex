defmodule AptamerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :aptamer

  @session_options [
    store: :cookie,
    key: "_aptamer_key",
    signing_salt: "Lge7Tfm3"
  ]

  socket "/socket", AptamerWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]
  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static, at: "/", from: :aptamer, gzip: false, only: ~w(css fonts images js favicon.ico robots.txt)
  # only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :aptamer
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug AptamerWeb.Router

  def init(:supervisor, opts) do
    {:ok, Aptamer.EnvConfig.override_endpoint_config(System.get_env(), opts)}
  end
end
