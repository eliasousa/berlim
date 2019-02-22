defmodule Berlim.InternalAccountsTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.InternalAccounts
  alias Comeonin.Bcrypt

  describe "admins" do
    alias Berlim.InternalAccounts.Admin

    @valid_attrs params_for(:admin)
    @update_attrs %{name: "Lionel Ritchie"}
    @invalid_attrs %{name: nil, email: nil}

    test "list_admins/0 returns all admins" do
      admin = insert(:admin)
      assert InternalAccounts.list_admins() == [admin]
    end

    test "get_admin!/1 returns the admin with given id" do
      admin = insert(:admin)
      assert InternalAccounts.get_admin!(admin.id) == admin
    end

    test "create_admin/1 with valid data creates a admin" do
      assert {:ok, %Admin{} = admin} = InternalAccounts.create_admin(@valid_attrs)
      assert admin.name == "John Doe"
      assert admin.active == true
      assert Bcrypt.check_pass(admin, "1234abcd") == {:ok, admin}
    end

    test "create_admin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InternalAccounts.create_admin(@invalid_attrs)
    end

    test "update_admin/2 with valid data updates the admin" do
      admin = insert(:admin)
      assert {:ok, admin} = InternalAccounts.update_admin(admin, @update_attrs)
      assert %Admin{} = admin
      assert admin.name == "Lionel Ritchie"
    end

    test "update_admin/2 with invalid data returns error changeset" do
      admin = insert(:admin)
      assert {:error, %Ecto.Changeset{}} = InternalAccounts.update_admin(admin, @invalid_attrs)
      assert admin == InternalAccounts.get_admin!(admin.id)
    end

    test "delete_admin/1 deletes the admin" do
      admin = insert(:admin)
      assert {:ok, %Admin{}} = InternalAccounts.delete_admin(admin)
      assert_raise Ecto.NoResultsError, fn -> InternalAccounts.get_admin!(admin.id) end
    end

    test "change_admin/1 returns a admin changeset" do
      admin = insert(:admin)
      assert %Ecto.Changeset{} = InternalAccounts.change_admin(admin)
    end
  end

  describe "taxis" do
    alias Berlim.InternalAccounts.Taxi

    @create_attrs params_for(:taxi)
    @update_attrs %{cpf: "12345678910"}
    @invalid_attrs %{cpf: nil, email: nil}

    test "list_taxis/0 returns all taxis" do
      taxi = insert(:taxi)
      assert InternalAccounts.list_taxis() == [taxi]
    end

    test "get_taxi/1 returns the taxi with given id" do
      taxi = insert(:taxi)
      assert InternalAccounts.get_taxi!(taxi.id).id == taxi.id
    end

    test "create_taxi/1 with valid data creates a taxi" do
      assert {:ok, taxi} = InternalAccounts.create_taxi(@create_attrs)
      assert taxi.cpf == "02005445698"
      assert taxi.active == true
      assert Bcrypt.check_pass(taxi, "1234abcd") == {:ok, taxi}
    end

    test "create_taxi/1 with invalid data returns error changeset" do
      assert {:error, _changeset} = InternalAccounts.create_taxi(@invalid_attrs)
    end

    test "update_taxi/2 with valid data updates the taxi" do
      taxi = insert(:taxi)
      assert {:ok, taxi} = InternalAccounts.update_taxi(taxi, @update_attrs)
      assert %Taxi{} = taxi
      assert taxi.cpf == "12345678910"
    end

    test "update_taxi/2 with invalid data returns error changeset" do
      taxi = insert(:taxi)
      assert {:error, _taxi} = InternalAccounts.update_taxi(taxi, @invalid_attrs)
    end

    test "change_taxi/0 returns a taxi changeset" do
      assert %Ecto.Changeset{} = InternalAccounts.change_taxi()
    end

    test "change_taxi/1 returns a taxi changeset" do
      taxi = insert(:taxi)
      assert %Ecto.Changeset{} = InternalAccounts.change_taxi(taxi)
    end

    test "change_taxi/2 returns a taxi changeset" do
      taxi = insert(:taxi)
      assert %Ecto.Changeset{} = InternalAccounts.change_taxi(taxi, @update_attrs)
    end
  end

  describe "authenticate admin tests" do
    setup do
      %{admin: insert_user_with_this_password(:admin, "1234")}
    end

    test "authenticate_user/1 with valid admin email and password, returns the admin with the given email",
         %{admin: admin} do
      assert {:ok, admin} =
               InternalAccounts.authenticate_user(%{"email" => admin.email, "password" => "1234"})
    end

    test "authenticate_user/1 with invalid admin email, returns invalid user-identifier error",
         %{admin: admin} do
      refute admin.email === "invalid@email"

      assert {:error, "incorrect username or password"} =
               InternalAccounts.authenticate_user(%{
                 "email" => "invalid@email",
                 "password" => "1234"
               })
    end

    test "authenticate_user/1 with invalid admin password, returns invalid password error",
         %{admin: admin} do
      assert {:error, "invalid password"} =
               InternalAccounts.authenticate_user(%{
                 "email" => admin.email,
                 "password" => "invalid"
               })
    end

    test "authenticate_user/1 with empty admin email, returns empty params error" do
      assert {:error, "empty params"} =
               InternalAccounts.authenticate_user(%{"email" => "", "password" => "1234"})
    end

    test "authenticate_user/1 with empty admin password, returns empty params error",
         %{admin: admin} do
      assert {:error, "empty params"} =
               InternalAccounts.authenticate_user(%{"email" => admin.email, "password" => ""})
    end

    test "authenticate_user/1 with empty admin email and password, returns empty params error" do
      assert {:error, "empty params"} =
               InternalAccounts.authenticate_user(%{"email" => "", "password" => ""})
    end
  end

  describe "authenticate taxi tests" do
    setup do
      %{taxi: insert_user_with_this_password(:taxi, "1234")}
    end

    test "authenticate_user/1 with valid taxi email and password, returns the taxi with the given email",
         %{taxi: taxi} do
      assert {:ok, taxi} =
               InternalAccounts.authenticate_user(%{"email" => taxi.email, "password" => "1234"})
    end

    test "authenticate_user/1 with invalid taxi email, returns invalid user-identifier error",
         %{taxi: taxi} do
      refute taxi.email === "invalid@email"

      assert {:error, "incorrect username or password"} =
               InternalAccounts.authenticate_user(%{
                 "email" => "invalid@email",
                 "password" => "1234"
               })
    end

    test "authenticate_user/1 with invalid taxi password, returns invalid password error",
         %{taxi: taxi} do
      assert {:error, "invalid password"} =
               InternalAccounts.authenticate_user(%{
                 "email" => taxi.email,
                 "password" => "invalid"
               })
    end

    test "authenticate_user/1 with empty taxi email, returns empty params error" do
      assert {:error, "empty params"} =
               InternalAccounts.authenticate_user(%{"email" => "", "password" => "1234"})
    end

    test "authenticate_user/1 with empty taxi password, returns empty params error",
         %{taxi: taxi} do
      assert {:error, "empty params"} =
               InternalAccounts.authenticate_user(%{"email" => taxi.email, "password" => ""})
    end

    test "authenticate_user/1 with empty taxi email and password, returns empty params error" do
      assert {:error, "empty params"} =
               InternalAccounts.authenticate_user(%{"email" => "", "password" => ""})
    end
  end
end
