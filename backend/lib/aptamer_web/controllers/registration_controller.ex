defmodule AptamerWeb.RegistrationController do
  use AptamerWeb, :controller

  alias Aptamer.Auth.{Registration, User}

  plug :accepts, ~w(json)

  def create(conn, %{"registration" => registration_params}) do
    with {:ok, valid_registration} <- load(registration_params),
         user <- User.register(valid_registration),
         {:ok, user} <- Repo.insert(user) do
      conn
      |> put_status(:created)
      |> render("show.json", data: user)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AptamerWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  defp load(registration_params) do
    reg = Registration.changeset(%Registration{}, registration_params)

    if reg.valid? do
      {:ok, Ecto.Changeset.apply_changes(reg)}
    else
      {:error, reg}
    end
  end
end
