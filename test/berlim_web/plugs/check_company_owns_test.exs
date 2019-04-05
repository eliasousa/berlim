defmodule BerlimWeb.Plugs.CheckCompanyOwnsTest do
  use BerlimWeb.ConnCase, async: true

  import BerlimWeb.Plugs.CheckCompanyOwns, only: [call: 2]
  import Berlim.Factory

  alias Berlim.Guardian

  describe "sector" do
    setup [:sign_in_company]

    test "when company owns the sector, company pass through the connection", %{
      conn: conn,
      company: company
    } do
      conn =
        :sector
        |> insert_factory(company)
        |> add_params(conn)
        |> call(:sector)

      assert conn.status != 403
    end

    test "when company does not own the sector, send error message", %{conn: conn} do
      conn =
        insert_factory(:sector)
        |> add_params(conn)
        |> call(:sector)

      assert conn.status == 403
      assert conn.resp_body =~ "Você não pode acessar esse recurso"
    end
  end

  describe "employee" do
    setup [:sign_in_company]

    test "when company owns the employee, company pass through the connection", %{
      conn: conn,
      company: company
    } do
      conn =
        :employee
        |> insert_factory(company)
        |> add_params(conn)
        |> call(:employee)

      assert conn.status != 403
    end

    test "when company does not own the employee, send error message", %{conn: conn} do
      conn =
        insert_factory(:employee)
        |> add_params(conn)
        |> call(:employee)

      assert conn.status == 403
      assert conn.resp_body =~ "Você não pode acessar esse recurso"
    end
  end

  defp sign_in_company(%{conn: conn}) do
    company = insert(:company)
    conn = Guardian.Plug.sign_in(conn, company)

    %{conn: conn, company: company}
  end

  defp insert_factory(factory_name, company \\ insert(:company)) do
    factory_name
    |> build(%{company: company})
    |> insert()
  end

  defp add_params(struct, conn) do
    %{conn | params: %{"company_id" => struct.company_id, "id" => struct.id}}
  end
end
