defmodule Aptamer.Jobs.SaveScriptOutputsOnDisk do
  @behaviour Aptamer.Jobs.PythonScriptJob.ScriptOutput

  @impl Aptamer.Jobs.PythonScriptJob.ScriptOutput
  def files(state) do
    state
  end

  @impl Aptamer.Jobs.PythonScriptJob.ScriptOutput
  def results(results) do
    zip_file = results.archive
    File.write!("test_script.zip", zip_file, [:binary, :write])
  end
end
