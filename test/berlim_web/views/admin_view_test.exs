defmodule BerlimWeb.AdminViewTest do
  use BerlimWeb.ConnCase, async: true

  import Berlim.Factory
  alias BerlimWeb.AdminView

  setup do
    admin = insert(:admin)

    %{
      admin: admin,
      admin_json: %{
        id: admin.id,
        name: admin.name,
        email: admin.email,
        phone: admin.phone,
        active: admin.active
      }
    }
  end

  describe "index.json/2" do
    test "returns admins", %{admin: admin, admin_json: admin_json} do
      assert AdminView.render("index.json", %{admins: [admin]}) == %{data: [admin_json]}
    end
  end

  describe "show.json/2" do
    test "returns admin", %{admin: admin, admin_json: admin_json} do
      assert AdminView.render("show.json", %{admin: admin}) == %{data: admin_json}
    end
  end

  describe "admin.json/2" do
    test "returns admin", %{admin: admin, admin_json: admin_json} do
      assert AdminView.render("admin.json", %{admin: admin}) == admin_json
    end
  end
end
