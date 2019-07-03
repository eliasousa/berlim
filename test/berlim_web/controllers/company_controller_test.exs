defmodule BerlimWeb.CompanyControllerTest do
  use BerlimWeb.ConnCase, async: true
  use BerlimWeb.Helpers.AuthHelper

  import Berlim.Factory

  alias Berlim.CompanyAccounts
  alias Berlim.CompanyAccounts.Company
  alias BerlimWeb.CompanyView

  @create_attrs params_for(:company, %{password: "1234abcd"})
  @update_attrs %{name: "Jaya"}
  @invalid_attrs %{cnpj: nil, email: nil}

  describe "GET /index, when user is an admin" do
    setup [:authenticate_admin]

    test "lists all companies", %{conn: conn} do
      conn = get(conn, Routes.company_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "GET /index, when user is not an admin" do
    setup [:authenticate_company]

    test "renders unauthorized", %{conn: conn} do
      conn = get(conn, Routes.company_path(conn, :index))
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "GET /show, when user is an admin" do
    setup [:create_company, :authenticate_admin]

    test "renders company", %{conn: conn, company: company} do
      conn = get(conn, Routes.company_path(conn, :show, company))

      assert json_response(conn, 200) ==
               render_json(CompanyView, "show.json", %{company: company})
    end
  end

  describe "GET /show, when user is not an admin" do
    setup [:create_company, :authenticate_company]

    test "renders unauthorized", %{conn: conn, company: company} do
      conn = get(conn, Routes.company_path(conn, :show, company))
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "POST /create, when user is an admin" do
    setup [:authenticate_admin]

    test "renders company when data is valid", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :create), company: @create_attrs)
      company = CompanyAccounts.get_company!(json_response(conn, 201)["data"]["id"])

      assert json_response(conn, 201) ==
               render_json(CompanyView, "show.json", %{company: company})
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :create), company: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "POST /create, when user is not an admin" do
    setup [:authenticate_company]

    test "renders unauthorized", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :create), company: @create_attrs)
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  describe "PUT /update, when user is an admin" do
    setup [:create_company, :authenticate_admin]

    test "renders company when data is valid", %{conn: conn, company: %Company{id: id} = company} do
      conn = put(conn, Routes.company_path(conn, :update, company), company: @update_attrs)
      company = CompanyAccounts.get_company!(id)

      assert json_response(conn, 200) ==
               render_json(CompanyView, "show.json", %{company: company})

      assert json_response(conn, 200)["data"]["name"] == "Jaya"
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn = put(conn, Routes.company_path(conn, :update, company), company: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "PUT /update, when user is not an admin" do
    setup [:create_company, :authenticate_company]

    test "renders unauthorized", %{conn: conn, company: company} do
      conn = put(conn, Routes.company_path(conn, :update, company), company: @update_attrs)
      assert json_response(conn, 403)["error"] == "Você não pode acessar esse recurso"
    end
  end

  defp create_company(_) do
    %{company: insert(:company)}
  end

  defp authenticate_admin(%{conn: conn}) do
    authenticate(conn, insert(:admin))
  end

  defp authenticate_company(%{conn: conn}) do
    authenticate(conn, insert(:company))
  end
end
