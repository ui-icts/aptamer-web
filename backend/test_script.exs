defmodule TestScript do
  alias Aptamer.Jobs.{PredictStructureOptions, CreateGraphOptions, PythonScriptJob, ScriptInput}

  def go do
    options = PredictStructureOptions.default()

    script =
      PythonScriptJob.create(
        "predict_structures.py",
        PredictStructureOptions.args(options),
        ScriptInput.from_disk_file("/Users/cortman/icts/aptamer/scripts/samples/Trunc_Test.fa")
      )

    # require IEx
    # IEx.pry()
    output = PythonScriptJob.run(script)
    IO.puts("A ha!")
    IO.inspect(output, label: "script")
  end
end

TestScript.go()
