defmodule Aptamer.BinaryIdColums do
  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__([]) do
    quote do
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
