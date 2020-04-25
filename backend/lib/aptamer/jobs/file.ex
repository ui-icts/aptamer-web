defmodule Aptamer.Jobs.File do
  use Ecto.Schema
  use Aptamer.BinaryIdColums
  use Aptamer.UtcMicroTimestamps

  import Ecto.Changeset
  import Ecto.Query
  alias Aptamer.Repo
  alias Aptamer.Jobs.{File, CreateGraphOptions, PredictStructureOptions, ScriptInput}

  @derive {Inspect, except: [:data]}

  schema "files" do
    field(:file_name, :string)
    field(:uploaded_on, :utc_datetime)
    # structure or fasta
    field(:file_type, :string)
    field(:data, :binary)
    field(:sequence_count, :integer, default: 0)
    belongs_to(:owner, Aptamer.Auth.User, foreign_key: :owner_id)
    has_many(:jobs, Aptamer.Jobs.Job)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(%File{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:file_name, :uploaded_on, :file_type, :data, :owner_id, :sequence_count])
    |> validate_required([:file_name, :uploaded_on, :file_type, :owner_id])
  end

  def new(file_path) do
    file_data = Elixir.File.read!(file_path)

    %File{
      file_name: Path.basename(file_path),
      data: file_data,
      file_type: guess_file_type(file_data),
      uploaded_on: DateTime.truncate(DateTime.utc_now(), :second),
      sequence_count: count_sequences(file_data)
    }
  end


  def build_script_args(job) do
    build_script_args(job.file, job)
  end

  def build_script_args(file, job) do
    cond do
      job.predict_structure_options ->
        {"predict_structures.py", PredictStructureOptions.args(job.predict_structure_options),
          ScriptInput.from_database_file(file)
        }

      job.create_graph_options ->
        {"create_graph.py", CreateGraphOptions.args(job.create_graph_options),
          ScriptInput.from_database_file(file)
        }

      true ->
        {:error, "No options associated with job"}
    end
  end

  def guess_file_type(contents) when is_binary(contents) do
    [one,two,three] = String.split(contents, "\n") |> Enum.take(3)
    IO.puts(three)
    case three do
      ">" <> rest -> "fasta"
      "." <> rest -> "structure"
      "(" <> rest -> "structure"
      ")" <> rest -> "structure"
      _ -> "unknown"
    end
  end

  def count_sequences(contents) when is_binary(contents) do
    lines = String.split(contents, "\n")
    contents
    |> String.split("\n")
    |> Enum.reject(fn line ->
      String.starts_with?(line, ~W/> ; . ( )/) || (String.trim(line) == "")
    end)
    |> Enum.count
  end
end
