defmodule TestScript do
  alias Aptamer.Jobs.{PredictStructureOptions, CreateGraphOptions, PythonScriptJob}
  def go do

    options = PredictStructureOptions.default()
    input_file = File.read!("/Users/cortman/icts/aptamer/scripts/samples/Trunc_Test.fa")

    script = PythonScriptJob.create(
      "predict_structures.py",
      PredictStructureOptions.args(options),
      input_file,
      Aptamer.Jobs.SaveScriptOutputsOnDisk
    )

    {:ok, output} = PythonScriptJob.run(script)
    IO.puts "A ha!"
    IO.inspect(output, label: "script")
  end
end

TestScript.go
