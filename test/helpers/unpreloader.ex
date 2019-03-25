defmodule Berlim.Helpers.Unpreloader do
  @moduledoc """
  Module with method to unpreload ExMachina associations
  """

  def unpreload(struct, field, cardinality \\ :one) do
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
