defmodule AptamerWeb.SessionControllerTest do
  use AptamerWeb.ConnCase

  import Aptamer.Factory


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "token for valid user", %{conn: conn} do
    user = insert(:user, password: "welcome")
    params = %{
      "grant_type" => "password",
      "username" => user.email,
      "password" => "welcome"
    }

    conn = post conn, login_path(conn,:create), params
    assert %{"access_token" => _token} = json_response(conn, 201)
    
  end

end
