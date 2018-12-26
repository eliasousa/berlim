defmodule Berlim.ParseHelpers do
  @moduledoc """
  This module helps to parse
  """

  def parse_date(date) do
    case Timex.parse(date, "{D}/{0M}/{YYYY}") do
      {:ok, parsed_date} ->
        parsed_date

      {:error, "Input datetime string cannot be empty!"} ->
        nil
    end
  end
end
