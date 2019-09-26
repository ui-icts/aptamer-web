defmodule AptamerWeb.InputHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  def semantic_form_for(form_data, url, opts \\ [], fun) do
    opts =
      if Map.get(form_data, :is_valid?) == false do
        Keyword.put(opts, :class, "ui form error")
      else
        Keyword.put(opts, :class, "ui form")
      end

    Phoenix.HTML.Form.form_for(form_data, url, opts, fun)
  end

  def input(form, field, opts \\ []) do
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "field #{state_class(form, field)}"]
    label_opts = [class: "sr-only"]
    input_opts = [placeholder: humanize(field)]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = input(type, form, field, input_opts)
      error = AptamerWeb.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end

  def large_submit_button(text) do
    content_tag :button, class: "ui fluid large submit button" do
      text
    end
  end

  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.source.action -> ""
      form.errors[field] -> "error"
      true -> "success"
    end
  end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
