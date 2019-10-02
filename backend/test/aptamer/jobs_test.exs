defmodule Aptamer.JobsTest do
  use Aptamer.DataCase, async: true
  import Aptamer.Factory

  alias Aptamer.Jobs

  setup do
    file = insert(:file)
    {:ok, test_file: file}
  end

  test "creates create_graph job", %{test_file: test_file} do
    options = %{
      "create_graph_options" => string_params_for(:create_graph_options)
    }

    assert {:ok, file, job} = Jobs.create_new_job(test_file, options)

    assert job.file_id == test_file.id
    assert is_nil(job.predict_structure_options_id)
    assert :loaded == job.create_graph_options.__meta__.state
  end

  test "creates predict_structures job", %{test_file: test_file} do
    options = %{
      "predict_structure_options" => string_params_for(:predict_structure_options)
    }

    assert {:ok, file, job} = Jobs.create_new_job(test_file, options)
    assert job.file_id == test_file.id
    assert is_nil(job.create_graph_options_id)
    assert :loaded == job.predict_structure_options.__meta__.state
  end

  test "cant force a file id in via the params", %{test_file: test_file} do
    options = %{
      "file_id" => "00000",
      "predict_structure_options" => string_params_for(:predict_structure_options)
    }

    assert {:ok, file, job} = Jobs.create_new_job(test_file, options)
    assert job.file_id == test_file.id
  end
end
