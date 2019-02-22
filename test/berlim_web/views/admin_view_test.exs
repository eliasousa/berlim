defmodule BerlimWeb.AdminViewTest do
  use BerlimWeb.ConnCase, async: true

  alias BerlimWeb.AdminView

  setup do
    %{
      admin: %{
        id: 1,
        name: "John Doe",
        email: "johndoe@voo.com",
        phone: "0799944859",
        active: true
      }
    }
  end

  describe "index.json/2" do
    test "returns admins", %{admin: admin} do
      assert AdminView.render("index.json", %{admins: [admin]}) == %{data: [admin]}
    end
  end

  describe "show.json/2" do
    test "returns admin", %{admin: admin} do
      assert AdminView.render("show.json", %{admin: admin}) == %{data: admin}
    end
  end

  describe "admin.json/2" do
    test "returns admin", %{admin: admin} do
      assert AdminView.render("admin.json", %{admin: admin}) == admin
    end
  end
end
