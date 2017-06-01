defmodule Aptamer.JobControllerTest do
  use Aptamer.ConnCase

  import Aptamer.Factory

  alias Aptamer.Job
  alias Aptamer.Repo

  @valid_attrs %{status: "some content"}
  @invalid_attrs %{status: ""}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships(file) do 

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
    conn = get conn, job_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    job =  insert(:job)

    conn = get conn, job_path(conn, :show, job)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{job.id}"
    assert data["type"] == "jobs"
    assert data["attributes"]["status"] == job.status
    assert data["relationships"]["file"]["data"] == %{"type" => "files", "id" => job.file.id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, job_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    file = insert(:file)

    conn = post conn, job_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "jobs",
        "attributes" => @valid_attrs,
        "relationships" => relationships(file)
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    query_args = Map.put(@valid_attrs, :file_id, file.id)
    assert Repo.get_by(Job, query_args)

  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    file = insert(:file)
    conn = post conn, job_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "jobs",
        "attributes" => @invalid_attrs,
        "relationships" => relationships(file)
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    file = insert(:file)

    # Not linking job/file yet...doing that with update call
    job = insert(:job)

    conn = put conn, job_path(conn, :update, job), %{
      "meta" => %{},
      "data" => %{
        "type" => "jobs",
        "id" => job.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships(file)
      }
    }

    query_args = Map.put(@valid_attrs, :file_id, file.id)
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Job, query_args)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    job = insert(:job)
    conn = put conn, job_path(conn, :update, job), %{
      "meta" => %{},
      "data" => %{
        "type" => "jobs",
        "id" => job.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships(job.file)
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    job = insert(:job)
    conn = delete conn, job_path(conn, :delete, job)
    assert response(conn, 204)
    refute Repo.get(Job, job.id)
  end

end
