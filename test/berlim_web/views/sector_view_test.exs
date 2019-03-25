defmodule BerlimWeb.SectorViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.SectorView

  setup do
    %{
      sector: %{
        id: 1,
        name: "Financeiro"
      }
    }
  end

  describe "index.json/2" do
    test "return sectors", %{sector: sector} do
      assert SectorView.render("index.json", %{sectors: [sector]}) == %{data: [sector]}
    end
  end

  describe "show.json/2" do
    test "returns sector", %{sector: sector} do
      assert SectorView.render("show.json", %{sector: sector}) == %{data: sector}
    end
  end

  describe "sector.json/2" do
    test "returns sector", %{sector: sector} do
      assert SectorView.render("sector.json", %{sector: sector}) == sector
    end
  end
end
