defmodule BerlimWeb.SectorController do
  use BerlimWeb, :controller

  alias Berlim.{
    CompanyAccounts,
    CompanyAccounts.Sector,
    Guardian
  }

  action_fallback BerlimWeb.FallbackController

  def index(conn, _params) do
    sectors = CompanyAccounts.list_company_sectors(current_company(conn).id)
    render(conn, "index.json", sectors: sectors)
  end

  def create(conn, %{"sector" => sector_params}) do
    sector_params = Map.put(sector_params, "company_id", current_company(conn).id)

    with {:ok, %Sector{} = sector} <- CompanyAccounts.create_sector(sector_params) do
      conn
      |> put_status(:created)
      |> render("show.json", sector: sector)
    end
  end

  def show(conn, %{"id" => id}) do
    sector = CompanyAccounts.get_sector!(id)
    render(conn, "show.json", sector: sector)
  end

  def update(conn, %{"id" => id, "sector" => sector_params}) do
    sector = CompanyAccounts.get_sector!(id)

    with {:ok, %Sector{} = sector} <-
           CompanyAccounts.update_sector(sector, sector_params) do
      render(conn, "show.json", sector: sector)
    end
  end

  defp current_company(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
