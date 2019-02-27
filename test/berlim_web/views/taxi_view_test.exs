defmodule BerlimWeb.TaxiViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.TaxiView

  setup do
    %{
      taxi: %{
        id: 1,
        cpf: "12345678910",
        smtt: 1234,
        email: "johndoe@taxi.com",
        phone: "0799944859",
        active: true
      }
    }
  end

  describe "index.json/2" do
    test "returns taxis", %{taxi: taxi} do
      assert %{data: [taxi]} = TaxiView.render("index.json", %{taxis: [taxi]})
    end
  end

  describe "show.json/2" do
    test "returns taxi", %{taxi: taxi} do
      assert %{data: taxi} = TaxiView.render("show.json", %{taxi: taxi})
    end
  end

  describe "taxi.json/2" do
    test "returns taxi", %{taxi: taxi} do
      assert TaxiView.render("taxi.json", %{taxi: taxi}) == taxi
    end
  end
end
