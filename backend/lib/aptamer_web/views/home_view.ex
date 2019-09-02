defmodule AptamerWeb.HomeView do
  use AptamerWeb, :view
  import AptamerWeb.JobHelpers

  def active_class(maybe_truthy) do
    if maybe_truthy do
      "active"
    else
      ""
    end
  end

  def menu_items() do
    file_types = [
      %{
        value: 'structure',
        text: 'Structure',
        operationText: 'Create Graph',
        selected: false
      },
      %{
        value: 'fasta',
        text: 'FASTA',
        operationText: 'Create Structure',
        selected: false
      },
      %{
        value: 'unknown',
        text: 'Unknown',
        operationText: 'Assign Filetype',
        selected: false
      }
    ]

    file_types
  end
end
