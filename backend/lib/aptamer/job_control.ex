defmodule Aptamer.JobControl do
  # use GenServer
  
  alias Aptamer.{Repo, PredictStructureOptions, CreateGraphOptions}

  defmodule RunningJob do
    defstruct job_id: "UNSET", output: []

    defimpl Collectable do
      def into(job) do
        {[], fn
          list, {:cont, output} -> 
            Aptamer.Endpoint.broadcast("jobs:" <> job.job_id, "job_output", %{job_id: job.job_id, lines: [output]})
            [output|list]
          list, :done -> %{job | output: Enum.reverse(list)}
          _, :halt -> :ok
        end}
      end
    end

  end



  def start_job(%Aptamer.Job{} = job) do
    Task.start(fn ->

      job = set_status(job, "preparing")
      broadcast_status(job)

      job =
        job
        |> Repo.preload(:create_graph_options)
        |> Repo.preload(:predict_structure_options)
        |> Repo.preload(:file)


      {:ok, temp_path} = Temp.mkdir job.id
      input_file = Path.join(temp_path, "inputdata.aptamer")
      File.write input_file, job.file.data

      {script_name, program_args} = case job.file.file_type do
        "structure" -> {"create_graph.py", CreateGraphOptions.args(job.create_graph_options)}
        "fasta" -> {"predict_structures.py", PredictStructureOptions.args(job.predict_structure_options)}
      end

      common_args = [
        "-u",
        "/Users/cortman/icts/aptamer/python-scripts/#{script_name}",
        input_file
      ]

      args = common_args ++ program_args

      try do

        job = set_status(job, "running")
        broadcast_status(job)

        running_job = %RunningJob{job_id: job.id}

        {output, _exit_status} = System.cmd(
          "/Users/cortman/.virtualenvs/aptamer-runtime/bin/python",
          args,
          cd: temp_path,
          into: running_job
        )

        job = set_status(job, "gathering outputs")
        broadcast_status(job)

        # if we ran predict_structures create
        # a structure file from the output
        if script_name == "predict_structures.py" do
          {:ok, file_data} = Path.join(temp_path, "inputdata.aptamer.struct.fa") |> Elixir.File.read
          file_struct = %Aptamer.File{
            file_name: "#{job.file.file_name}.struct.fa",
            uploaded_on: DateTime.utc_now(),
            file_type: "structure",
            data: file_data
          }
          {:ok, file_struct} = Repo.insert(file_struct)
        end

        File.rm input_file
        if File.exists?(Path.join(temp_path,"dot.ps")) do
          File.rm Path.join(temp_path, "dot.ps")
        end

        ## Gather all files excluding any dot.ps
        #and create a zip archive
        files = File.ls!(temp_path)
        |> Enum.map(fn filename -> Path.join(temp_path, filename) end)
        |> Enum.map(&String.to_charlist/1)

        :zip.create(Path.join(temp_path,"#{job.file.file_name}.zip"), files)

        ## Insert the zip file into database
        {:ok, zip_data} = Elixir.File.read(Path.join(temp_path, "#{job.file.file_name}.zip"))
        zip_struct = %Aptamer.File{
          file_name: "#{job.file.file_name}.zip",
          uploaded_on: DateTime.utc_now(),
          file_type: "#{job.file.file_type}-output",
          data: zip_data
        }

        {:ok, zip_struct} = Repo.insert(zip_struct)

        job = set_status(job, "cleaning up")
        broadcast_status(job)

        File.rmdir temp_path

        job = set_status(job, "finished", output)
        broadcast_status(job)

      rescue

        e in ArgumentError ->
          Aptamer.Endpoint.broadcast("jobs:" <> job.id, "job_output", %{job_id: job.id, lines: [ArgumentError.message(e)]})
          set_status(job, "failed")
          broadcast_status(job)
      end
    end)
  end

  defp set_status(job, status, output \\ nil) do

    output = case output do
      %RunningJob{output: x} -> Enum.join(x, "\n")
      nil -> nil
    end
    cs = Aptamer.Job.changeset(job, %{status: status, output: output})

    {:ok, job} = Repo.update cs
    job
  end

  defp broadcast_status(job) do
    json = JaSerializer.format( Aptamer.JobView, job )
    Aptamer.Endpoint.broadcast("jobs:status", "status_change", json)
  end
  ##
  # Client
  #

  # def start_link(opts \\ []) do
  #   GenServer.start_link(__MODULE__,:ok,opts)
  # end
  #
  # def submit_job(server, job) do
  #   GenServer.call(server, {:submit, job})
  # end

  ##
  # Server
  #

  # def init(:ok) do
  #   {:ok, []}
  # end
  #
  # def handle_call({:submit, job}, from, job_list) do
  #   {:reply, :ok, []}
  # end
end
