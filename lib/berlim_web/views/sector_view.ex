defmodule BerlimWeb.SectorView do
  use BerlimWeb, :view
  alias BerlimWeb.SectorView

  def render("index.json", %{sectors: sectors}) do
    %{data: render_many(sectors, SectorView, "sector.json")}
  end

  def render("show.json", %{sector: sector}) do
    %{data: render_one(sector, SectorView, "sector.json")}
  end

  def render("sector.json", %{sector: sector}) do
    %{
      id: sector.id,
      name: sector.name
    }
  end
end
