defmodule Aptamer.PredictStructureOptionsControllerTest do
  use Aptamer.ConnCase

  import Aptamer.Factory

  alias Aptamer.PredictStructureOptions
  alias Aptamer.Repo

  @valid_attrs %{pass_options: "some content", prefix: "some content", run_mfold: true, suffix: "some content", vienna_version: 42}
  @invalid_attrs %{}

  setup do
    current_user = insert(:user)
    conn = build_conn()
      |> guardian_login(current_user)
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do
    %{}
  end

  defp relationships(%Aptamer.File{} = file) do
    %{
      "file" => %{
        "data" => %{
          "type" => "files",
          "id" => file.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    insert_list(3, :predict_structure_options)
    conn =
      conn
      |> get(predict_structure_options_path(conn, :index))

    data = json_response(conn,200)["data"]

    assert [%{"type" => "predict-structure-options"},%{},%{}] = data
  end

  test "shows chosen resource", %{conn: conn} do
    predict_structure_options = Repo.insert! %PredictStructureOptions{}
    conn = get conn, predict_structure_options_path(conn, :show, predict_structure_options)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{predict_structure_options.id}"
    assert data["type"] == "predict-structure-options"
    assert data["attributes"]["run-mfold"] == predict_structure_options.run_mfold
    assert data["attributes"]["vienna-version"] == predict_structure_options.vienna_version
    assert data["attributes"]["prefix"] == predict_structure_options.prefix
    assert data["attributes"]["suffix"] == predict_structure_options.suffix
    assert data["attributes"]["pass-options"] == predict_structure_options.pass_options
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, predict_structure_options_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    file = insert(:file)
    attrs = build(:predict_structure_options, file: file)

    json = %{
      "data" => %{
        "type" => "predict-structure-options",
        "attributes" => %{
          "run-mfold" => attrs.run_mfold,
          "vienna-version" => attrs.vienna_version,
          "prefix" => attrs.prefix,
          "suffix" => attrs.suffix,
          "pass-options" => attrs.pass_options
         },
        "relationships" => relationships(file)
      }
    } |> Poison.encode!

    conn = post conn, predict_structure_options_path(conn, :create), json

    assert json_response(conn, 201)["data"]["id"]

    created = Repo.get_by(PredictStructureOptions, %{
      run_mfold: attrs.run_mfold,
      vienna_version: attrs.vienna_version,
      prefix: attrs.prefix,
      suffix: attrs.suffix,
      pass_options: attrs.pass_options
    })

    assert created != nil

    created = Repo.preload(created, file: :owner)
    assert created.file == file
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, predict_structure_options_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "predict-structure-options",
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    predict_structure_options = insert(:predict_structure_options)
    conn = put conn, predict_structure_options_path(conn, :update, predict_structure_options), %{
      "meta" => %{},
      "data" => %{
        "type" => "predict-structure-options",
        "id" => predict_structure_options.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PredictStructureOptions, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    predict_structure_options = Repo.insert! %PredictStructureOptions{}
    conn = put conn, predict_structure_options_path(conn, :update, predict_structure_options), %{
      "meta" => %{},
      "data" => %{
        "type" => "predict-structure-options",
        "id" => predict_structure_options.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    predict_structure_options = Repo.insert! %PredictStructureOptions{}
    conn = delete conn, predict_structure_options_path(conn, :delete, predict_structure_options)
    assert response(conn, 204)
    refute Repo.get(PredictStructureOptions, predict_structure_options.id)
  end

end
