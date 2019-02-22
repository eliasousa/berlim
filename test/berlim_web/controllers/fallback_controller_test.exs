defmodule BerlimWeb.FallbackControllerTest do
  use BerlimWeb.ConnCase

  alias Berlim.InternalAccounts.Admin
  alias BerlimWeb.FallbackController

  describe "call/2 with changeset" do
    test "responds with 422", %{conn: conn} do
      changeset = Admin.changeset(%Admin{}, %{})
      conn = FallbackController.call(conn, {:error, changeset})

      assert conn.status == 422
    end
  end
end
