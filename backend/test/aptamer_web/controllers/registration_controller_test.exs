defmodule AptamerWeb.RegistrationControllerTest do
  use AptamerWeb.ConnCase

  @valid_attrs %{email: "bob@example.com", name: "Bob", password: "welcome"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end


  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), registration: @valid_attrs
    response = json_response(conn, 201)
    assert Repo.get(Aptamer.Auth.User, response["data"]["id"])
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), registration: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

end
