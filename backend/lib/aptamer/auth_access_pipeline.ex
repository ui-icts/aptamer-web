defmodule Aptamer.AuthAccessPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :aptamer,
    module: Aptamer.Guardian,
    error_handler: Aptamer.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

defmodule Aptamer.BrowserAuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :aptamer,
    module: Aptamer.Guardian,
    error_handler: Aptamer.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifySession
  # plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
