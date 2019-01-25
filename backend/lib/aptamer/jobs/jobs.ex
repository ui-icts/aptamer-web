defmodule Aptamer.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Aptamer.Repo

  alias Aptamer.Jobs.File

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  def list_files do
    raise "TODO"
  end

  @doc """
  Gets a single file.

  Raises if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

  """
  def get_file!(id), do: raise "TODO"

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, ...}

  """
  def create_file(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, ...}

  """
  def update_file(%File{} = file, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a File.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, ...}

  """
  def delete_file(%File{} = file) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Todo{...}

  """
  def change_file(%File{} = file) do
    raise "TODO"
  end

  alias Aptamer.Jobs.Job

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

  """
  def list_jobs do
    raise "TODO"
  end

  @doc """
  Gets a single job.

  Raises if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

  """
  def get_job!(id), do: raise "TODO"

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, ...}

  """
  def create_job(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, ...}

  """
  def update_job(%Job{} = job, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, ...}

  """
  def delete_job(%Job{} = job) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Todo{...}

  """
  def change_job(%Job{} = job) do
    raise "TODO"
  end
end
