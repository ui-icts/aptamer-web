defmodule AptamerWeb.HealthController do
  use AptamerWeb, :controller

  def index(conn, _params) do
    with {:ok, _ } <- test_database_connection(),
         {:ok, _} <- test_python_modules() do
      send_resp(conn, 200, "healthy")
    else
      {:error, _ } ->
        send_resp(conn,500,"sick")
    end
  end

  defp test_database_connection() do
    Ecto.Adapters.SQL.query(Aptamer.Repo, "SELECT 1")
  end

  defp test_python_modules() do
    case System.cmd("python",["-c","import aptamer.predict_structures; import aptamer.create_graph"]) do
      {x,0} ->
        {:ok, x}
      {x,1} ->
        {:error, x}
    end
  end
end
