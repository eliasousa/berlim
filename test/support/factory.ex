defmodule Berlim.Factory do
  @moduledoc """
  Module that loads all factories used on our tests
  """

  use ExMachina.Ecto, repo: Berlim.Repo
  use Berlim.InternalAccountsFactory
end
