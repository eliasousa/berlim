defmodule BerlimWeb.Plugs.CheckCompanyOwns do
  @moduledoc """
  The check company owns Plug
  """

  import Plug.Conn

  import Phoenix.Controller, only: [json: 2]

  alias Berlim.{
    CompanyAccounts.Company,
    CompanyAccounts.Employee,
    CompanyAccounts.Sector,
    Guardian,
    Repo
  }

  def init(params), do: params

  def call(conn, params) do
    case params do
      :sector ->
        company_owns(Sector, conn)

      :employee ->
        company_owns(Employee, conn)

      _not_match ->
        error_return_and_halt(conn)
    end
  end

  defp company_owns(model, conn) do
    with %Company{} = company <- Guardian.Plug.current_resource(conn),
         struct when not is_nil(struct) <- Repo.get(model, conn.params["id"]),
         true <- struct.company_id == company.id do
      conn
    else
      _not_owner ->
        error_return_and_halt(conn)
    end
  end

  defp error_return_and_halt(conn) do
    conn
    |> put_status(403)
    |> json(%{error: "Você não pode acessar esse recurso"})
    |> halt()
  end
end
