defmodule Aptamer.Jobs.PythonScriptJob do
  require Logger

  alias Aptamer.Repo

  defmodule ScriptInput do
    require Logger

    def new(input_file) do
      if is_file_path?(input_file) do
        #{:file_path, input_file}
        %{file_name: Path.basename(input_file), file_path: Path.expand(input_file), file_contents: nil}
      else
        #{:file_contents, input_file}
        %{file_name: "temp_input", file_path: nil, file_contents: input_file}
      end
    end

    def is_file_path?(thing) do
      full_path = Path.expand(thing)
      Elixir.File.exists?(full_path)
    end

    def path_and_contents(state, temp_path) do

      {path, contents} = case {state.file_path, state.file_contents} do
        {nil, some} ->
          Logger.debug("Generating input file from file contents")
          temp_file = Path.join(temp_path, state.file_name)
          File.write(temp_file, some)
          {temp_file, some}

        {some, nil} ->
          Logger.debug("Generating input file from file path #{some}")

          {:ok, contents} = Elixir.File.read(some)
          {some, contents}

        {x, y} ->
          {x, y}
      end

      %{state | file_path: path, file_contents: contents}
    end

    def absolute_path_on_disk(state) do
      ## Assumption that path and contents have already been called
      # so that we know file_path is set!
      state.file_path
    end

    def file_name(state) do
      state.file_name
    end
  end


  alias Aptamer.Jobs.PythonScriptJob.ScriptInput

  defstruct script_name: nil,
            args: [],
            working_dir: nil,
            exit_code: nil,
            results: nil,

            # Used to broadcast status notifications, which step we are one
            listener: nil,

            current_user_id: nil,

            # Unique identifier for the job ... we use it when
            # we create the temp directory and (currently) to insert
            # the result struct
            job_id: 0,

            input: nil,
            output: nil,

            generated_file: nil

  defmodule ScriptOutput do
    @callback files(%Aptamer.Jobs.PythonScriptJob{}) :: %Aptamer.Jobs.PythonScriptJob{}
    @callback result(%Aptamer.Jobs.Result{}) :: %Aptamer.Jobs.Result{}
  end

  def create({script_name, args, input_file}), do: create(script_name, args, input_file)
  def create(script_name, args, input_file, output \\ nil) do
    %Aptamer.Jobs.PythonScriptJob{
      script_name: script_name,
      args: args,
      input: ScriptInput.new(input_file),
      output: output
    }
  end

  def run(%Aptamer.Jobs.PythonScriptJob{} = state) do
    Logger.debug("Running python job: #{inspect(state)}")

    {:ok, state}
    |> execute_step(:prepare_files)
    |> execute_step(:run_script)
    |> execute_step(:process_outputs)
    |> execute_step(:cleanup)
  end

  def execute_step({:ok, state}, step_name) do
    broadcast(:begin, step_name, state)
    result = step(step_name, state)
    broadcast(:finish, step_name, state)
    result
  end

  def broadcast(action, step_name, %Aptamer.Jobs.PythonScriptJob{listener: nil}) do
    Logger.info("[BROADCAST] - #{action} #{step_name}")
  end

  def broadcast(action, step_name, %Aptamer.Jobs.PythonScriptJob{listener: listener})
      when is_pid(listener) do
    send(listener, {:broadcast, {action, step_name}})
  end

  def step(:prepare_files, state) do
    {:ok, temp_path} = Temp.mkdir(state.job_id)

    input = ScriptInput.path_and_contents(state.input, temp_path)

    {:ok, %{state | working_dir: temp_path, input: input}}
  end

  def step(:run_script, state) do
    python_path = path(:python)
    script_path = path(:script)

    common_args = [
      Path.join(script_path,state.script_name),
      ScriptInput.absolute_path_on_disk(state.input)
    ]

    args = common_args ++ state.args

    {lines, exit_status} =
      System.cmd(
        python_path,
        args,
        cd: state.working_dir,
        stderr_to_stdout: true,
        parallelism: true,
        into: []
      )

    program_output = Enum.join(lines, "\n")

    results = """
    Program exited with code: #{exit_status}

    Output
    ---------------------------------------------------------
    #{program_output}
    """

    results_path = Path.join(state.working_dir, "program_output.txt")
    File.write(results_path, results)

    state = %{state | exit_code: exit_status}
    {:ok, state}
  end

  def step(:process_outputs, state) do
    # if we ran predict_structures create
    # a structure file from the output

    state = if state.output, do: state.output.files(state), else: state
    remove_extraneous_files(state.working_dir)

    results =
      zip_outputs(
        state.working_dir,
        state.job_id,
        "#{ScriptInput.file_name(state.input)}.zip"
      )

    results = if state.output,  do: state.output.results(results), else: results
    {:ok, %{state | results: results}}
  end

  def step(:cleanup, state) do
    File.rmdir(state.working_dir)

    {:ok, state}
  end

  def path(type) do
    case type do
      :python ->
        System.get_env("APTAMER_PYTHON") ||
          "#{System.user_home()}/.virtualenvs/aptamer-runtime-3/bin/python"

      :script ->
        System.get_env("APTAMER_SCRIPT") || "#{System.user_home()}/icts/aptamer/scripts/aptamer"
    end
  end

  def zip_outputs(output_directory, job_id, zip_file_name) do
    ## Gather all files excluding any dot.ps
    # and create a zip archive
    files =
      File.ls!(output_directory)
      |> Enum.map(&String.to_charlist/1)

    :zip.create(Path.join(output_directory, zip_file_name), files, [{:cwd, output_directory}])

    {:ok, zip_data} = Elixir.File.read(Path.join(output_directory, zip_file_name))

    zip_struct = %Aptamer.Jobs.Result{
      archive: zip_data,
      job_id: job_id
    }

    
  end

  def remove_extraneous_files(output_directory) do
    dot_ps = Path.join(output_directory, "dot.ps")

    if File.exists?(dot_ps) do
      File.rm(dot_ps)
    end
  end

end
