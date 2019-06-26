defmodule BerlimWeb.Old.EmployeeController do
  use BerlimWeb, :controller

  alias Bcrypt
  alias Berlim.{CompanyAccounts.Employee, Repo}

  def show(conn, %{"funcionario_id" => id, "empresa_id" => company_id, "password" => password}) do
    case Employee |> Repo.get_by(id: id, company_id: company_id) |> Repo.preload(:company) do
      employee = %Employee{} ->
        if Bcrypt.verify_pass(password, employee.encrypted_password) do
          json(
            conn,
            %{
              id: employee.id,
              ativo: employee.active,
              empresa: %{
                ativo: employee.company.active
              }
            }
          )
        else
          json(conn, false)
        end

      nil ->
        json(conn, false)
    end
  end

  def show(conn, _params) do
    json(conn, false)
  end
end
