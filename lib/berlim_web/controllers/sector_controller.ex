defmodule BerlimWeb.SectorController do
  use BerlimWeb, :controller

  alias Berlim.CompanyAccounts
  alias Berlim.CompanyAccounts.Sector

  action_fallback BerlimWeb.FallbackController

  def index(conn, %{"company_id" => company_id}) do
    sectors = CompanyAccounts.list_company_sectors(company_id)
    render(conn, "index.json", sectors: sectors)
  end

  def create(conn, %{"sector" => sector_params, "company_id" => company_id}) do
    sector_params = Map.put(sector_params, "company_id", company_id)

    with {:ok, %Sector{} = sector} <- CompanyAccounts.create_sector(sector_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.sector_path(conn, :show, sector.company_id, sector))
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
end
