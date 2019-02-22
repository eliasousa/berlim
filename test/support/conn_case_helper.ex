defmodule BerlimWeb.ConnCaseHelper do
  @moduledoc """
  Utility methods for tests
  """

  def render_json(view, template, assigns) do
    template
    |> view.render(assigns)
    |> format_json
  end

  def format_json(data) do
    data
    |> Jason.encode!()
    |> Jason.decode!()
  end
end
