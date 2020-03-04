defmodule Aptamer.Jobs.PythonScriptJob do
  require Logger

  alias Aptamer.Jobs.ScriptInput
  alias Aptamer.Jobs.PythonScriptJob

  alias Elixir.File, as: FS
  # Name of the script being run
  defstruct script_name: nil,
            # Arguments to be given to the script
            args: [],
            # Represents the file input, can be a path to file or raw contents
            input: nil,

            # Temporary directory where files are written & read
            # for processing
            working_dir: nil,

            # Exite code of the script
            exit_code: nil,

            # Used to capture any output files that might be
            # inputs into other jobs
            generated_file: nil,

            # Stores the .zip archive of the jobs outputs
            archive: nil

  def create({script_name, args, input_file}), do: create(script_name, args, input_file)

  def create(script_name, args, input_file) do
    %PythonScriptJob{
      script_name: script_name,
      args: args,
      input: input_file
    }
  end

  def run(%PythonScriptJob{} = state) do
    Logger.debug("Running python job: #{inspect(state)}")

    state
    |> prepare_files()
    |> IO.inspect()
    |> run_script()
    |> IO.inspect()
    |> save_generated_files()
    |> IO.inspect()
    |> zip_outputs()
    |> cleanup()
  end

  def prepare_files(state) do
    {:ok, temp_path} = Temp.mkdir()
    input = ScriptInput.copy_to_temp_path(state.input, temp_path)
    %{state | working_dir: temp_path, input: input}
  end

  def run_script(state) do
    {python_path, args} = build_args(state)

    {lines, exit_status} =
      System.cmd(
        python_path,
        args,
        cd: state.working_dir,
        stderr_to_stdout: true,
        parallelism: true,
        # -- Use this to see the output in your terminal IO.stream(:stdio,:line)
        into: []
      )

    IO.puts("CMD finished")
    program_output = Enum.join(lines, "\n")

    results = """
    Command:

    #{python_path} #{Enum.join(args, " ")}

    Program exited with code: #{exit_status}

    Output
    ---------------------------------------------------------
    #{program_output}
    """

    results_path = Path.join(state.working_dir, "program_output.txt")
    FS.write(results_path, results)

    %{state | exit_code: exit_status}
  end

  defp build_args(state) do
    python_path = System.find_executable("python")
    input_file_name = ScriptInput.file_name(state.input)

    python_module = case state.script_name do
      "predict_structures.py" -> "aptamer.predict_structures"
      "create_graph.py" -> "aptamer.create_graph"
      _ ->
        raise "Unknown script name #{state.script_name}"
    end

    common_args = [
      "-m",
      python_module,
      Path.join(state.working_dir, input_file_name)
    ]

    args = common_args ++ state.args
    {python_path, args}
  end

  def print_command_line(state) do
    {python_path, args} = build_args(state)

    cli = """
    pushd #{state.working_dir} && \\
    #{python_path} #{Enum.join(args, " ")} ; \\
    popd
    """

    IO.puts(cli)
    :ok
  end

  def save_generated_files(state) do
    structure_file = structure_file_path(state)

    case {state.script_name, state.exit_code} do
      {"predict_structures.py", 0} ->
        if FS.exists?(structure_file) do
          # TODO: Maybe worth just storing a file name and contents in
          # a tuple instead of the File struct ? That would completely
          # decouple running the script from our storage impl
          %{state | generated_file: Aptamer.Jobs.File.new(structure_file)}
        else
          state
        end

      _ ->
        state
    end
  end

  def zip_outputs(state) do
    # if we ran predict_structures create
    # a structure file from the output

    remove_extraneous_files(state.working_dir)

    archive =
      zip_directory_contents(state.working_dir, "#{ScriptInput.file_name(state.input)}.zip")

    %{state | archive: archive}
  end

  def cleanup(state) do
    FS.rmdir(state.working_dir)
    %{state | working_dir: nil}
  end

  defp structure_file_path(state) do
    Path.join(
      state.working_dir,
      [ScriptInput.file_name(state.input), ".struct.fa"]
    )
  end

  defp zip_directory_contents(output_directory, zip_file_name) do
    ## Gather all files excluding any dot.ps
    # and create a zip archive
    files =
      FS.ls!(output_directory)
      |> Enum.map(&String.to_charlist/1)

    :zip.create(Path.join(output_directory, zip_file_name), files, [{:cwd, output_directory}])

    {:ok, zip_data} = FS.read(Path.join(output_directory, zip_file_name))

    zip_data

    # zip_struct = %Aptamer.Jobs.Result{
    #   archive: zip_data,
    #   job_id: job_id
    # }
  end

  defp remove_extraneous_files(output_directory) do
    dot_ps = Path.join(output_directory, "dot.ps")

    if FS.exists?(dot_ps) do
      FS.rm(dot_ps)
    end
  end
end
