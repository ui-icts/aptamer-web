defmodule Aptamer.Jobs.PythonScriptJob do

  require IEx

  alias Aptamer.Repo

  defstruct script_name: nil,
    args: [],
    working_dir: nil,
    output: [],
    exit_code: nil,
    listener: nil,
    current_user_id: nil,
    job_id: nil,
    input_file_name: nil, #The original name of the file
    input_file_contents: nil, #The contents
    input_file_path: nil, #The temp path where we've written it for processing
    output_collector: nil


  def create(script_name, args, input_file) do

    full_path = Path.expand(input_file)
    {file_name, file_path, file_contents} = cond do
      Elixir.File.exists?(full_path) -> {Path.basename(input_file), full_path, nil}
      true -> {"temp_input", nil, input_file}
    end

    %Aptamer.Jobs.PythonScriptJob{
      script_name: script_name,
      args: args,
      input_file_name: file_name,
      input_file_path: file_path,
      input_file_contents: file_contents
    }
  end

  def run(%Aptamer.Jobs.PythonScriptJob{} = state) do

    {:ok, state} = execute_step(:prepare_files, state)
    {:ok, state} = execute_step(:run_script, state)
    {:ok, state} = execute_step(:process_outputs, state)
    {:ok, state} = execute_step(:cleanup, state)
  end

  def execute_step(step_name, state) do
    broadcast :begin, step_name, state
    result = step step_name, state
    broadcast :finish, step_name, state
    result
  end

  def broadcast(action, step_name, %Aptamer.Jobs.PythonScriptJob{listener: nil}) do
    IO.puts "[BROADCAST] - #{action} #{step_name}"
  end

  def broadcast(action, step_name, %Aptamer.Jobs.PythonScriptJob{listener: listener}) when is_pid(listener) do
    send(listener, {:broadcast, {action, step_name}})
  end

  def step(:prepare_files, state) do
    {:ok, temp_path} = Temp.mkdir state.job_id

    {path,contents} = case {state.input_file_path, state.input_file_contents} do

      {nil, some} ->

        temp_file = Path.join(temp_path, "inputdata.aptamer")
        File.write temp_file, some
        {temp_file, some}

      {some, nil} -> 
        {:ok, contents} = Elixir.File.read(some)
        {some, contents}

      {x,y} -> {x,y}

    end

    {:ok, %{state | working_dir: temp_path, input_file_path: path, input_file_contents: contents}}
  end

  def step(:run_script, state) do
    python_path = System.get_env("APTAMER_PYTHON") || "/Users/cortman/.virtualenvs/aptamer-runtime/bin/python"
    script_path = System.get_env("APTAMER_SCRIPT") || "/Users/cortman/icts/aptamer/scripts"

    common_args = [
      "#{script_path}/#{state.script_name}",
      state.input_file_path
    ]

    args = common_args ++ state.args

    command_file = Path.join(state.working_dir, "command.sh")
    File.write(command_file, python_path <> " " <> Enum.join(args, " "))

    collector = state.output_collector || IO.stream(:stdio, :line)

    {collector, exit_status} = System.cmd(
      python_path,
      args,
      cd: state.working_dir,
      into: collector
    )


    output = case collector do
      %Aptamer.JobControl.RunningJob{output: x} -> x 
      %IO.Stream{} -> []
      [h|t] = lines -> lines
      _ -> []
    end |> Enum.join("\n")


    results = """
    Program exited with code: #{exit_status}

    Output
    ---------------------------------------------------------
    #{output}
    """
    
    results_path = Path.join(state.working_dir,"results.log")
    File.write(results_path, results)

    state = %{state | output: output, exit_code: exit_status}
    {:ok, state}
  end

  def step(:process_outputs, state) do
    # if we ran predict_structures create
    # a structure file from the output

    if state.script_name == "predict_structures.py" && state.exit_code == 0 do
      create_structure_file_from_outputs(
        state.working_dir,
        "#{state.input_file_name}.struct.fa",
        state.current_user_id
      )
    end

    remove_extraneous_files(state.working_dir)

    {:ok, zip_struct} = zip_outputs(
      state.working_dir,
      state.job_id,
      "#{state.input_file_name}.zip"
    )

    {:ok, state}
  end

  def zip_outputs( output_directory, job_id, zip_file_name ) do
    ## Gather all files excluding any dot.ps
    #and create a zip archive
    files = File.ls!(output_directory)
            |> Enum.map(fn filename -> Path.join(output_directory, filename) end)
            |> Enum.map(&String.to_charlist/1)

    :zip.create(Path.join(output_directory,zip_file_name), files)

    {:ok, zip_data} = Elixir.File.read(Path.join(output_directory, zip_file_name))

    zip_struct = %Aptamer.Result{
      archive: zip_data,
      job_id: job_id
    }

    Repo.insert(zip_struct)

  end

  def remove_extraneous_files(output_directory) do
    dot_ps = Path.join(output_directory,"dot.ps")
    if File.exists?(dot_ps) do
      File.rm dot_ps
    end
  end

  def create_structure_file_from_outputs(output_directory, new_file_name, file_owner_id) do

    structure_file = Path.join(output_directory, "inputdata.aptamer.struct.fa")

    case Elixir.File.read(structure_file) do
      {:ok, file_data} ->

        file_struct = %Aptamer.File{
          file_name: new_file_name,
          uploaded_on: DateTime.utc_now(),
          file_type: "structure",
          data: file_data,
          owner_id: file_owner_id
        }

        Repo.insert(file_struct)
      {:error, _} ->
        IO.puts "Unable to read generated structure file"
        #Don't do anything if we can't read the file

    end

  end

  def step(:cleanup, state) do
    File.rmdir state.working_dir

    {:ok, state}
  end
end
