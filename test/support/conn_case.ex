defmodule BerlimWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox
  alias Phoenix.ConnTest

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias BerlimWeb.Router.Helpers, as: Routes
      import BerlimWeb.ConnCaseHelper

      # The default endpoint for testing
      @endpoint BerlimWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Berlim.Repo)

    unless tags[:async] do
      Sandbox.mode(Berlim.Repo, {:shared, self()})
    end

    {:ok, conn: ConnTest.build_conn()}
  end
end
