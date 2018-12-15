defmodule Berlim.AccountsTest do
  use Berlim.DataCase

  import Berlim.Factory

  alias Berlim.Accounts

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
      assert admin.password == "1234abcd"
      assert admin.active == true
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

    @valid_attrs params_for(:taxi)
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
      assert Accounts.get_taxi!(taxi.id) == taxi
    end

    test "create_taxi/1 with valid data creates a taxi" do
      assert {:ok, taxi} = Accounts.create_taxi(@valid_attrs)
      assert taxi.cpf == "02005445698"
      assert taxi.password == "1234abcd"
      assert taxi.active == true
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
      assert %Ecto.Changeset{} = Accounts.change_taxi(taxi, @valid_attrs)
    end
  end
end
