defmodule AptamerWeb.SessionController do
  use AptamerWeb, :controller

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt
  import Logger

  def create(conn, %{"grant_type" => "password",
        "username" => username,
        "password" => password}) do

    try do
      user =
        Aptamer.User
        |> where(email: ^username)
        |> Repo.one!
      cond do
        checkpw(password, user.password) ->
          Logger.info "User " <> username <> " logged in"
          conn = Aptamer.Guardian.Plug.sign_in(conn, user)
          jwt = Aptamer.Guardian.Plug.current_token(conn)

          conn
          |> put_status(:created)
          |> json(%{access_token: jwt})

        true ->
          Logger.warn "User " <> username <> " failed login"
          conn
          |> put_status(401)
          |> render(AptamerWeb.ErrorView, "401.json")

      end
    rescue
      e in Ecto.NoResultsError ->
        dummy_checkpw()
        Logger.warn "User " <> username <> " not found"
        conn
        |> put_status(401)
        |> render(AptamerWeb.ErrorView, "401.json")

      e ->
        IO.inspect e
        Logger.error "Error logging in user"
        conn
        |> put_status(401)
        |> render(AptamerWeb.ErrorView, "401.json")
    end
  end

  def create(conn, %{"grant_type" => _}) do
    throw "Unsupported grant_type"
  end

  def show(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    render(conn, AptamerWeb.UserView, "show.json-api", %{data: current_user})
  end
end
