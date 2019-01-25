defmodule Aptamer.Guardian do
  use Guardian, otp_app: :aptamer

  alias Aptamer.Repo
  alias Aptamer.Auth.User

  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = "#{resource.id}"
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    id = claims["sub"]
    resource = Repo.get(User, id)
    {:ok,  resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  defmodule AuthErrorHandler do
    import Plug.Conn

    @behaviour Guardian.Plug.ErrorHandler

    @impl Guardian.Plug.ErrorHandler
    def auth_error(conn, {type, reason}, _opts) do
      body = Jason.encode!(%{message: to_string(type)})
      conn = put_resp_header(conn, "content-type", "application/json")
      send_resp(conn, 401, body)
    end
  end
end
