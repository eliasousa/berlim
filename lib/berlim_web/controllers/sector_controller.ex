defmodule BerlimWeb.SectorController do
  use BerlimWeb, :controller

  alias Berlim.{
    CompanyAccounts,
    CompanyAccounts.Sector
  }

  action_fallback BerlimWeb.FallbackController

  def index(%{assigns: %{company: company}} = conn, _params) do
    sectors = CompanyAccounts.list_company_sectors(company.id)
    render(conn, "index.json", sectors: sectors)
  end

  def create(%{assigns: %{company: company}} = conn, %{"sector" => sector_params}) do
    with {:ok, %Sector{} = sector} <- CompanyAccounts.create_sector(company, sector_params) do
      conn
      |> put_status(:created)
      |> render("show.json", sector: sector)
    end
  end

  def show(%{assigns: %{company: company}} = conn, %{"id" => id}) do
    sector = CompanyAccounts.get_sector!(id, company.id)
    render(conn, "show.json", sector: sector)
  end

  def update(%{assigns: %{company: company}} = conn, %{"id" => id, "sector" => sector_params}) do
    sector = CompanyAccounts.get_sector!(id, company.id)

    with {:ok, %Sector{} = sector} <-
           CompanyAccounts.update_sector(sector, sector_params) do
      render(conn, "show.json", sector: sector)
    end
  end
end
