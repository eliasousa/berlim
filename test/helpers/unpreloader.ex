defmodule Berlim.Helpers.Unpreloader do
  @moduledoc """
  Module with method to unpreload ExMachina associations
  """

  def unpreload(struct, field, cardinality \\ :one)

  def unpreload(struct, fields, cardinality) when is_list(fields) do
    Enum.reduce(fields, struct, fn field, struct ->
      build_not_loaded(struct, field, cardinality)
    end)
  end

  def unpreload(struct, field, cardinality) do
    build_not_loaded(struct, field, cardinality)
  end

  defp build_not_loaded(struct, field, cardinality) do
    %{
      struct
      | field => %Ecto.Association.NotLoaded{
          __field__: field,
          __owner__: struct.__struct__,
          __cardinality__: cardinality
        }
    }
  end
end
