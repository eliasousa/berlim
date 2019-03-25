defmodule BerlimWeb.Plugs.CheckSectorOwner do
  @moduledoc """
  The check sector owner Plug
  """

  import Plug.Conn

  import Phoenix.Controller, only: [json: 2]

  alias Berlim.{
    CompanyAccounts.Company,
    CompanyAccounts.Sector,
    Guardian,
    Repo
  }

  def init(params), do: params

  def call(conn, _params) do
    with %Company{} = company <- Guardian.Plug.current_resource(conn),
         sector when not is_nil(sector) <- Repo.get(Sector, conn.params["id"]),
         true <- sector.company_id == company.id do
      conn
    else
      _not_owner ->
        conn
        |> put_status(401)
        |> json(%{error: "Você não pode fazer isso"})
        |> halt()
    end
  end
end
