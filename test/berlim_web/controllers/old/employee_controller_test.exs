defmodule BerlimWeb.Old.EmployeeControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  describe "GET /show, when id and company_id match with password" do
    setup [:authenticate]

    test "renders employee", %{conn: conn} do
      employee = insert_user_with_this_password(:employee, "123456")

      conn =
        get(
          conn,
          Routes.old_employee_path(conn, :show, %{
            "funcionario_id" => employee.id,
            "empresa_id" => employee.company_id,
            "password" => "123456"
          })
        )

      assert json_response(conn, 200) == %{
               "id" => employee.id,
               "ativo" => employee.active,
               "empresa" => %{"ativo" => employee.company.active}
             }
    end
  end

  describe "GET /show, when id and company_id does not match with password" do
    setup [:authenticate]

    test "renders false", %{conn: conn} do
      employee = insert_user_with_this_password(:employee, "123456")

      conn =
        get(
          conn,
          Routes.old_employee_path(conn, :show, %{
            "funcionario_id" => employee.id,
            "empresa_id" => employee.company_id,
            "password" => "invalid_pass"
          })
        )

      refute json_response(conn, 200)
    end
  end

  describe "GET /show, with invalid params" do
    setup [:authenticate]

    test "renders false", %{conn: conn} do
      conn = get(conn, Routes.old_employee_path(conn, :show, %{}))

      refute json_response(conn, 200)
    end
  end

  defp authenticate(%{conn: conn}) do
    authenticate_with_token(conn)
  end
end
