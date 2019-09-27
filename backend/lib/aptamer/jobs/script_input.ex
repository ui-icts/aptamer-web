defmodule Aptamer.Jobs.ScriptInput do
  require Logger

  def new(input_file) do
    if is_file_path?(input_file) do
        # {:file_path, input_file}
      %{
        file_name: Path.basename(input_file),
        file_path: Path.expand(input_file),
        file_contents: nil
      }
    else
        # {:file_contents, input_file}
      %{file_name: "temp_input", file_path: nil, file_contents: input_file}
    end
  end

  def is_file_path?(thing) do
    full_path = Path.expand(thing)
    Elixir.File.exists?(full_path)
  end

  def path_and_contents(state, temp_path) do
    {path, contents} =
      case {state.file_path, state.file_contents} do
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
