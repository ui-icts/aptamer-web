defmodule Aptamer.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Aptamer.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Aptamer.Router.Helpers

      # The default endpoint for testing
      @endpoint Aptamer.Endpoint

      def guardian_login(conn, user) do
        jwt =
          conn
          |> bypass_through(Aptamer.Router, [:browser])
          |> get("/")
          |> Guardian.Plug.api_sign_in(user)
          |> Guardian.Plug.current_token()

        conn =
          conn
          |> put_req_header( "authorization", "Bearer " <> jwt)


        conn
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Aptamer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Aptamer.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
