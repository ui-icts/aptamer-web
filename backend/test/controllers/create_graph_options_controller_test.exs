defmodule Aptamer.CreateGraphOptionsControllerTest do
  use Aptamer.ConnCase

  import Aptamer.Factory

  alias Aptamer.CreateGraphOptions
  alias Aptamer.Repo

  @valid_attrs %{edge_type: "some content", max_edit_distance: 42, max_tree_distance: 42, seed: true}
  @invalid_attrs %{}

  setup do
    current_user = insert(:user)
    conn = build_conn()
      |> guardian_login(current_user)
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships() do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    insert_list(3, :create_graph_options)
    conn =
      conn
      |> get(create_graph_options_path(conn, :index))

    data = json_response(conn,200)["data"]

    assert [%{"type" => "create-graph-options"},%{},%{}] = data
  end

  test "shows chosen resource", %{conn: conn} do
    create_graph_options = insert(:create_graph_options)
    conn = get conn, create_graph_options_path(conn, :show, create_graph_options)
    data = json_response(conn, 200)["data"]

    assert data["id"] == "#{create_graph_options.id}"
    assert data["type"] == "create-graph-options"
    assert data["attributes"]["edge-type"] == create_graph_options.edge_type
    assert data["attributes"]["seed"] == create_graph_options.seed
    assert data["attributes"]["max-edit-distance"] == create_graph_options.max_edit_distance
    assert data["attributes"]["max-tree-distance"] == create_graph_options.max_tree_distance
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, create_graph_options_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do

    attrs = build(:create_graph_options)
    
    json = %{
      "data" => %{
        "type" => "create-graph-options",
        "attributes" => %{
          "edge-type" => attrs.edge_type,
          "max_edit_distance" => attrs.max_edit_distance,
          "max_tree_distance" => attrs.max_tree_distance,
          "seed" => attrs.seed
        },
        "relationships" => relationships()

      }
    } |> Poison.encode!
    
    conn = post conn, create_graph_options_path(conn, :create), json

    assert json_response(conn, 201)["data"]["id"]
    created = Repo.get_by(CreateGraphOptions, %{edge_type: attrs.edge_type, seed: attrs.seed, max_edit_distance: attrs.max_edit_distance, max_tree_distance: attrs.max_tree_distance})
    assert created != nil
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, create_graph_options_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "create-graph-options",
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    create_graph_options = insert(:create_graph_options)

    conn = put conn, create_graph_options_path(conn, :update, create_graph_options), %{
      "meta" => %{},
      "data" => %{
        "type" => "create-graph-options",
        "id" => create_graph_options.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CreateGraphOptions, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    create_graph_options = Repo.insert! %CreateGraphOptions{}
    conn = put conn, create_graph_options_path(conn, :update, create_graph_options), %{
      "meta" => %{},
      "data" => %{
        "type" => "create-graph-options",
        "id" => create_graph_options.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    create_graph_options = Repo.insert! %CreateGraphOptions{}
    conn = delete conn, create_graph_options_path(conn, :delete, create_graph_options)
    assert response(conn, 204)
    refute Repo.get(CreateGraphOptions, create_graph_options.id)
  end

end
