defmodule BerlimWeb.Plugs.CheckSectorOwnerTest do
  use BerlimWeb.ConnCase, async: true

  import BerlimWeb.Plugs.CheckSectorOwner, only: [call: 2]
  import Berlim.Factory

  alias Berlim.Guardian

  describe "company owns the sector" do
    setup [:sign_in_company]

    test "company pass through the connection", %{conn: conn, company: company} do
      conn =
        company
        |> create_sector()
        |> add_params(conn)
        |> call(%{})

      assert conn.status != 401
    end
  end

  describe "company does not own the sector" do
    setup [:sign_in_company]

    test "send error message", %{conn: conn} do
      conn =
        create_sector()
        |> add_params(conn)
        |> call(%{})

      assert conn.status == 403
      assert conn.resp_body =~ "Você não pode acessar esse recurso"
    end
  end

  defp sign_in_company(%{conn: conn}) do
    company = insert(:company)
    conn = Guardian.Plug.sign_in(conn, company)

    %{conn: conn, company: company}
  end

  defp create_sector(company \\ insert(:company)) do
    :sector
    |> build(%{company: company})
    |> insert()
  end

  defp add_params(sector, conn) do
    %{conn | params: %{"company_id" => sector.company_id, "id" => sector.id}}
  end
end
