defmodule BerlimWeb.FallbackControllerTest do
  use BerlimWeb.ConnCase, async: true

  alias Berlim.InternalAccounts.Admin
  alias BerlimWeb.FallbackController

  describe "call/2 with changeset" do
    test "responds with 422", %{conn: conn} do
      changeset = Admin.changeset(%Admin{}, %{})
      conn = FallbackController.call(conn, {:error, changeset})

      assert conn.status == 422
    end
  end

  describe "call/2 with unauthorized" do
    test "responds with 401", %{conn: conn} do
      conn = FallbackController.call(conn, {:error, :unauthorized})

      assert conn.status == 401
    end
  end
end
