defmodule AptamerWeb.SessionController do
  use AptamerWeb, :controller

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt
  require Logger

  alias Aptamer.Auth.{Registration, User}

  defmodule LoginFormParams do
    use Ecto.Schema
    import Ecto.Changeset

    schema "" do
      field(:email, :string)
      field(:password, :string)
    end

    def blank(), do: changeset(__MODULE__.__struct__())

    def validate(params \\ %{}) do
      %LoginFormParams{}
      |> changeset(params)
      |> apply_action(:insert)
    end

    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:email, :password])
      |> validate_required([:email, :password])
    end
  end

  def new(conn, _params) do
    login_cs = LoginFormParams.blank()
    register_cs = Registration.blank()
    render(conn, :new, login_cs: login_cs, register_cs: register_cs)
  end

  def create(conn, %{"login_form_params" => form}) do
    case LoginFormParams.validate(form) do
      {:ok, login_form} ->
        try do
          user =
            Aptamer.Auth.User
            |> where(email: ^login_form.email)
            |> Repo.one!()

          cond do
            checkpw(login_form.password, user.password) ->
              Logger.info("User " <> user.email <> " logged in")
              conn = Aptamer.Guardian.Plug.sign_in(conn, user)

              conn
              |> redirect(to: "/")

            true ->
              Logger.warn("User " <> user.email <> " failed login")

              conn
              |> put_flash(:login_error, "Invalid username or password")
              |> redirect(to: "/sessions/new")
          end
        rescue
          Ecto.NoResultsError ->
            dummy_checkpw()
            Logger.warn("User " <> login_form.email <> " not found")

            conn
            |> put_flash(:login_error, "Invalid username or password")
            |> redirect(to: "/sessions/new")

          e ->
            Logger.error("Error logging in user")
            Logger.error(inspect(e))

            conn
            |> put_flash(:login_error, "Invalid username or password")
            |> redirect(to: "/sessions/new")
        end

      {:error, cs} ->
        conn
        |> put_flash(:login_error, "Could not login")
        |> render(:new, login_cs: cs, register_cs: Registration.blank())
    end
  end

  def create(conn, %{"registration" => form}) do
    reg = Registration.new_user(%Registration{}, form)

    if reg.valid? do
      {:ok, _user} =
        reg
        |> Ecto.Changeset.apply_changes()
        |> User.register()
        |> Repo.insert()

      conn
      |> render(:new, login_cs: LoginFormParams.blank(), register_cs: Registration.blank())
    else
      {:error, reg} = Ecto.Changeset.apply_action(reg, :insert)

      conn
      |> render(:new, login_cs: LoginFormParams.blank(), register_cs: reg)
    end
  end

  def create(conn, %{"grant_type" => "password", "username" => username, "password" => password}) do
    try do
      user =
        Aptamer.Auth.User
        |> where(email: ^username)
        |> Repo.one!()

      cond do
        checkpw(password, user.password) ->
          Logger.info("User " <> username <> " logged in")
          conn = Aptamer.Guardian.Plug.sign_in(conn, user)
          jwt = Aptamer.Guardian.Plug.current_token(conn)

          conn
          |> put_status(:created)
          |> json(%{access_token: jwt})

        true ->
          Logger.warn("User " <> username <> " failed login")

          conn
          |> put_status(401)
          |> put_view(AptamerWeb.ErrorView)
          |> render("401.json")
      end
    rescue
      Ecto.NoResultsError ->
        dummy_checkpw()
        Logger.warn("User " <> username <> " not found")

        conn
        |> put_status(401)
        |> put_view(AptamerWeb.ErrorView)
        |> render("401.json")

      _ ->
        Logger.error("Error logging in user")

        conn
        |> put_status(401)
        |> put_view(AptamerWeb.ErrorView)
        |> render("401.json")
    end
  end

  def create(_conn, %{"grant_type" => _}) do
    throw("Unsupported grant_type")
  end

  def show(conn, _params) do
    current_user = Aptamer.Guardian.Plug.current_resource(conn)

    conn
    |> put_view(AptamerWeb.UserView)
    |> render("show.json-api", %{data: current_user})
  end

  
  def logout(conn, _) do
    conn
    |> Aptamer.Guardian.Plug.sign_out()
    |> redirect(to: "/sessions/new")
  end
end
