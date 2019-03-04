defmodule BerlimWeb.CompanyViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.CompanyView

  setup do
    %{
      company: %{
        id: 1,
        name: "Voo de company",
        cnpj: "12345678910",
        email: "johndoe@company.com",
        active: true,
        phone: "0799944859"
      }
    }
  end

  describe "index.json/2" do
    test "returns companies", %{company: company} do
      assert CompanyView.render("index.json", %{companies: [company]}) == %{data: [company]}
    end
  end

  describe "show.json/2" do
    test "returns company", %{company: company} do
      assert CompanyView.render("show.json", %{company: company}) == %{data: company}
    end
  end

  describe "company.json/2" do
    test "returns company", %{company: company} do
      assert CompanyView.render("company.json", %{company: company}) == company
    end
  end
end
