defmodule Aptamer.Jobs.ScriptInput do
  require Logger

  @doc """
  Creates a new script input.
  Can be created from a file name and the contents incase the source
  is not a physical file on disk.

  Or can be a file path to a file on disk
  """
  def from_database_file(%{file_name: file_name, data: file_contents} = file) do
    {:database, file}
    # %{file_name: file_name, file_path: nil, file_contents: file_contents}
  end

  def from_disk_file(input_file) do
    if is_file_path?(input_file) do
      # {:file_path, input_file}
      {:disk, Path.expand(input_file)}
    else
      # {:file_contents, input_file}
      raise "Single argument to new script input must be a file path"
    end
  end

  def copy_to_temp_path(script_input, temp_path) do
    
    Logger.debug("Copying input file to temp_path")
    temp_file = Path.join(temp_path, file_name(script_input))
    case script_input do
      {:database, %{data: contents}} ->
          File.write(temp_file, contents)
      {:disk, file_path} ->
          File.cp(file_path, temp_file)
    end

    script_input
  end

  def file_name({:database, file}) do
    file.file_name
  end

  def file_name({:disk, file_path}) do
    Path.basename(file_path)
  end

  defp is_file_path?(thing) do
    full_path = Path.expand(thing)
    Elixir.File.exists?(full_path)
  end

end
