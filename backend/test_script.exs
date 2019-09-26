defmodule TestScript do
  alias Aptamer.Jobs.{PredictStructureOptions, CreateGraphOptions, PythonScriptJob}
  def go do

    options = PredictStructureOptions.default()
    input_file = File.read!("/Users/cortman/icts/aptamer/scripts/samples/Trunc_Test.fa")

    script = PythonScriptJob.create(
      "predict_structures.py",
      PredictStructureOptions.args(options),
      input_file
    )
    script = %{script | output_collector: []}

    {:ok, output} = PythonScriptJob.run(script)
    zip_file = output.results.archive
    File.write!("test_script.zip", zip_file, [:binary, :write])
    IO.puts "A ha!"
    IO.inspect(output, label: "script")
  end
end

TestScript.go
