defmodule AptamerWeb.LayoutViewTest do
  use AptamerWeb.ConnCase, async: true
  import Aptamer.Factory
  alias AptamerWeb.LayoutView

  test "no guardian token means not authenticated" do
    assert LayoutView.is_authenticated?(conn) == false
  end

  test "guardian token set means authenticated", %{conn: conn} do
    user = insert(:user)
    # I just need to get something so the conn will be in
    # same state it would be in during normal request
    # ...particularly so i tinvokes the guardian logic
    conn =
      conn
      |> guardian_login(user)
      |> get("/")

    assert LayoutView.is_authenticated?(conn) == true
  end
end
