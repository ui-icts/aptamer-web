defmodule Aptamer.Jobs.ScriptOutputInDatabase do
  @behaviour Aptamer.Jobs.PythonScriptJob.ScriptOutputs

  alias Aptamer.Jobs.PythonScriptJob
  alias Aptamer.Jobs.PythonScriptJob.ScriptInput
  alias Aptamer.Repo
  alias Aptamer.Jobs.Result

  require Logger

  def files(%PythonScriptJob{} = state) do
    if state.script_name == "predict_structures.py" && state.exit_code == 0 do
      Logger.debug("Creating structure file output")

      case create_structure_file_from_outputs(
             state.working_dir,
             "#{ScriptInput.file_name(state.input)}.struct.fa",
             state.current_user_id
           ) do
        {:ok, file} -> %{state | generated_file: file}
        _ -> state
      end
    else
      Logger.debug(
        "Not creating a structure file. script_name: #{inspect(state.script_name)} exit status: #{
          inspect(state.exit_code)
        }"
      )

      state
    end
  end

  def result(%Result{} = results) do
    # Temporary way to run one off jobs that
    # never go to the database
    unless results.job_id == 0 do
      {:ok, results} = Repo.insert(results)
      results
    else
      results
    end
  end

  def create_structure_file_from_outputs(output_directory, new_file_name, file_owner_id) do
    structure_file = Path.join(output_directory, new_file_name)

    case Elixir.File.read(structure_file) do
      {:ok, file_data} ->
        file_cs =
          Aptamer.Jobs.File.new_structure_file_changeset(
            new_file_name,
            file_data,
            file_owner_id
          )

        Repo.insert(file_cs)

      {:error, e} ->
        Logger.error("Unable to read generated structure file. #{inspect(e)}")
    end
  end
end
