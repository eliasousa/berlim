defmodule Berlim.InternalAccountsTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory
  import Swoosh.TestAssertions

  alias Berlim.{EmailGenerator, InternalAccounts}

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
      assert_email_sent(EmailGenerator.welcome(taxi.email, taxi.smtt, "1234abcd"))
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
end
