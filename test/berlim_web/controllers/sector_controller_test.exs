defmodule BerlimWeb.SectorControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  alias Berlim.{
    CompanyAccounts,
    Guardian
  }

  alias BerlimWeb.SectorView

  @create_attrs params_for(:sector)
  @update_attrs %{name: "Recursos Humanos"}
  @invalid_attrs %{name: nil}

  describe "GET /index" do
    setup [:authenticate_company, :company_from_token]

    test "list all sectors that belongs to a company", %{conn: conn, company: company} do
      conn = get(conn, Routes.sector_path(conn, :index, company.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "GET /show" do
    setup [:authenticate_company, :company_from_token, :create_sector]

    test "renders sector", %{conn: conn, sector: sector} do
      conn = get(conn, Routes.sector_path(conn, :show, sector.company_id, sector))
      assert json_response(conn, 200) == render_json(SectorView, "show.json", %{sector: sector})
    end
  end

  describe "POST /create" do
    setup [:authenticate_company, :company_from_token]

    test "renders sector when data is valid", %{conn: conn, company: company} do
      conn = post(conn, Routes.sector_path(conn, :create, company, sector: @create_attrs))
      sector = CompanyAccounts.get_sector!(json_response(conn, 201)["data"]["id"])

      assert json_response(conn, 201) ==
               render_json(SectorView, "show.json", %{sector: sector})
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn = post(conn, Routes.sector_path(conn, :create, company, sector: @invalid_attrs))

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PUT /update" do
    setup [:authenticate_company, :company_from_token, :create_sector]

    test "renders sector when data is valid", %{conn: conn, sector: sector} do
      conn =
        put(
          conn,
          Routes.sector_path(conn, :update, sector.company_id, sector, sector: @update_attrs)
        )

      sector = CompanyAccounts.get_sector!(json_response(conn, 200)["data"]["id"])

      assert json_response(conn, 200) == render_json(SectorView, "show.json", %{sector: sector})
      assert json_response(conn, 200)["data"]["name"] == "Recursos Humanos"
    end

    test "renders errors when data is invalid", %{conn: conn, sector: sector} do
      conn =
        put(
          conn,
          Routes.sector_path(conn, :update, sector.company_id, sector, sector: @invalid_attrs)
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_sector(%{company: company}) do
    sector =
      :sector
      |> build(%{company: company})
      |> insert()

    %{sector: sector}
  end

  defp company_from_token(%{conn: conn}) do
    with ["Bearer " <> token] = get_req_header(conn, "authorization"),
         {:ok, company, _claims} = Guardian.resource_from_token(token) do
      %{company: company}
    end
  end

  defp authenticate_company(%{conn: conn}) do
    authenticate(conn, insert(:company))
  end
end
