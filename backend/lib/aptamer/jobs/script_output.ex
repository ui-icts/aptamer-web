defmodule Aptamer.Jobs.ScriptOutput do
  @callback files(%Aptamer.Jobs.PythonScriptJob{}) :: %Aptamer.Jobs.PythonScriptJob{}
  @callback result(%Aptamer.Jobs.Result{}) :: %Aptamer.Jobs.Result{}
end
