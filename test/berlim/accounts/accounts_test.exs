defmodule Berlim.AccountsTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.Accounts
  alias Comeonin.Bcrypt

  describe "admins" do
    alias Berlim.Accounts.Admin

    @valid_attrs params_for(:admin)
    @update_attrs %{name: "Lionel Ritchie"}
    @invalid_attrs %{name: nil, email: nil}

    test "list_admins/0 returns all admins" do
      admin = insert(:admin)
      assert Accounts.list_admins() == [admin]
    end

    test "get_admin!/1 returns the admin with given id" do
      admin = insert(:admin)
      assert Accounts.get_admin!(admin.id) == admin
    end

    test "create_admin/1 with valid data creates a admin" do
      assert {:ok, %Admin{} = admin} = Accounts.create_admin(@valid_attrs)
      assert admin.name == "John Doe"
      assert admin.active == true
      assert Bcrypt.check_pass(admin, "1234abcd") == {:ok, admin}
    end

    test "create_admin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_admin(@invalid_attrs)
    end

    test "update_admin/2 with valid data updates the admin" do
      admin = insert(:admin)
      assert {:ok, admin} = Accounts.update_admin(admin, @update_attrs)
      assert %Admin{} = admin
      assert admin.name == "Lionel Ritchie"
    end

    test "update_admin/2 with invalid data returns error changeset" do
      admin = insert(:admin)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_admin(admin, @invalid_attrs)
      assert admin == Accounts.get_admin!(admin.id)
    end

    test "delete_admin/1 deletes the admin" do
      admin = insert(:admin)
      assert {:ok, %Admin{}} = Accounts.delete_admin(admin)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_admin!(admin.id) end
    end

    test "change_admin/1 returns a admin changeset" do
      admin = insert(:admin)
      assert %Ecto.Changeset{} = Accounts.change_admin(admin)
    end
  end

  describe "taxis" do
    alias Berlim.Accounts.Taxi

    @update_attrs %{cpf: "12345678910"}
    @invalid_attrs %{cpf: nil, email: nil}

    setup do
      %{taxi: insert(:taxi)}
    end

    test "list_taxis/1 returns the first 30 taxis ordered by smtt" do
      insert_list(44, :taxi)
      page = Accounts.list_taxis(%{page: 1})
      first_taxi = List.first(page.entries)
      last_taxi = List.last(page.entries)

      assert is_list(page.entries)
      assert Enum.count(page.entries) == 30
      assert first_taxi.smtt < last_taxi.smtt
      assert page.total_entries == 45
      assert page.total_pages == 2
    end

    test "get_taxi/1 returns the taxi with given id", %{taxi: taxi} do
      assert Accounts.get_taxi!(taxi.id).id == taxi.id
    end

    test "create_taxi/1 with valid data creates a taxi" do
      plan = insert(:plan)
      create_attrs = Map.merge(params_for(:taxi), %{plan_id: plan.id})

      assert {:ok, taxi} = Accounts.create_taxi(create_attrs)
      assert taxi.cpf == "02005445698"
      assert taxi.plan_id == plan.id
      assert taxi.active == true
      assert Bcrypt.check_pass(taxi, "1234abcd") == {:ok, taxi}
    end

    test "create_taxi/1 with invalid data returns error changeset" do
      assert {:error, _changeset} = Accounts.create_taxi(@invalid_attrs)
    end

    test "update_taxi/2 with valid data updates the taxi", %{taxi: taxi} do
      assert {:ok, taxi} = Accounts.update_taxi(taxi, @update_attrs)
      assert %Taxi{} = taxi
      assert taxi.cpf == "12345678910"
    end

    test "update_taxi/2 with invalid data returns error changeset", %{taxi: taxi} do
      assert {:error, _taxi} = Accounts.update_taxi(taxi, @invalid_attrs)
    end

    test "change_taxi/0 returns a taxi changeset" do
      assert %Ecto.Changeset{} = Accounts.change_taxi()
    end

    test "change_taxi/1 returns a taxi changeset", %{taxi: taxi} do
      assert %Ecto.Changeset{} = Accounts.change_taxi(taxi)
    end

    test "change_taxi/2 returns a taxi changeset", %{taxi: taxi} do
      assert %Ecto.Changeset{} = Accounts.change_taxi(taxi, @update_attrs)
    end
  end

  describe "authenticate admin tests" do
    setup do
      %{admin: insert_user_with_this_password(:admin, "1234")}
    end

    test "authenticate_user/1 with valid admin email and password, returns the admin with the given email",
         %{admin: admin} do
      assert {:ok, admin} =
               Accounts.authenticate_user(%{"email" => admin.email, "password" => "1234"})
    end

    test "authenticate_user/1 with invalid admin email, returns invalid user-identifier error",
         %{admin: admin} do
      refute admin.email === "invalid@email"

      assert {:error, "incorrect username or password"} =
               Accounts.authenticate_user(%{"email" => "invalid@email", "password" => "1234"})
    end

    test "authenticate_user/1 with invalid admin password, returns invalid password error",
         %{admin: admin} do
      assert {:error, "invalid password"} =
               Accounts.authenticate_user(%{"email" => admin.email, "password" => "invalid"})
    end

    test "authenticate_user/1 with empty admin email, returns empty params error" do
      assert {:error, "empty params"} =
               Accounts.authenticate_user(%{"email" => "", "password" => "1234"})
    end

    test "authenticate_user/1 with empty admin password, returns empty params error",
         %{admin: admin} do
      assert {:error, "empty params"} =
               Accounts.authenticate_user(%{"email" => admin.email, "password" => ""})
    end

    test "authenticate_user/1 with empty admin email and password, returns empty params error" do
      assert {:error, "empty params"} =
               Accounts.authenticate_user(%{"email" => "", "password" => ""})
    end
  end

  describe "authenticate taxi tests" do
    setup do
      %{taxi: insert_user_with_this_password(:taxi, "1234")}
    end

    test "authenticate_user/1 with valid taxi email and password, returns the taxi with the given email",
         %{taxi: taxi} do
      assert {:ok, taxi} =
               Accounts.authenticate_user(%{"email" => taxi.email, "password" => "1234"})
    end

    test "authenticate_user/1 with invalid taxi email, returns invalid user-identifier error",
         %{taxi: taxi} do
      refute taxi.email === "invalid@email"

      assert {:error, "incorrect username or password"} =
               Accounts.authenticate_user(%{"email" => "invalid@email", "password" => "1234"})
    end

    test "authenticate_user/1 with invalid taxi password, returns invalid password error",
         %{taxi: taxi} do
      assert {:error, "invalid password"} =
               Accounts.authenticate_user(%{"email" => taxi.email, "password" => "invalid"})
    end

    test "authenticate_user/1 with empty taxi email, returns empty params error" do
      assert {:error, "empty params"} =
               Accounts.authenticate_user(%{"email" => "", "password" => "1234"})
    end

    test "authenticate_user/1 with empty taxi password, returns empty params error",
         %{taxi: taxi} do
      assert {:error, "empty params"} =
               Accounts.authenticate_user(%{"email" => taxi.email, "password" => ""})
    end

    test "authenticate_user/1 with empty taxi email and password, returns empty params error" do
      assert {:error, "empty params"} =
               Accounts.authenticate_user(%{"email" => "", "password" => ""})
    end
  end
end
