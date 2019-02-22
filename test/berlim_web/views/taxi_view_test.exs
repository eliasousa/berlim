defmodule BerlimWeb.TaxiViewTest do
  use BerlimWeb.ConnCase, async: true

  import Berlim.Factory
  alias BerlimWeb.TaxiView

  setup do
    taxi = insert(:taxi)

    %{
      taxi: taxi,
      taxi_json: %{
        id: taxi.id,
        cpf: taxi.cpf,
        smtt: taxi.smtt,
        email: taxi.email,
        phone: taxi.phone,
        active: taxi.active
      }
    }
  end

  describe "index.json/2" do
    test "returns taxis", %{taxi: taxi, taxi_json: taxi_json} do
      assert TaxiView.render("index.json", %{taxis: [taxi]}) == %{data: [taxi_json]}
    end
  end

  describe "show.json/2" do
    test "returns taxi", %{taxi: taxi, taxi_json: taxi_json} do
      assert TaxiView.render("show.json", %{taxi: taxi}) == %{data: taxi_json}
    end
  end

  describe "taxi.json/2" do
    test "returns taxi", %{taxi: taxi, taxi_json: taxi_json} do
      assert TaxiView.render("taxi.json", %{taxi: taxi}) == taxi_json
    end
  end
end
