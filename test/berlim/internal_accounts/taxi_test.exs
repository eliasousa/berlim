defmodule Berlim.InternalAccounts.TaxiTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.InternalAccounts.Taxi

  @valid_attrs params_for(:taxi, %{password: "1234abcd"})

  test "changeset/2 with valid attributes" do
    changeset = Taxi.changeset(%Taxi{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with invalid attributes" do
    changeset = Taxi.changeset(%Taxi{}, %{})
    refute changeset.valid?
  end

  test "create_changeset/2 with valid attributes" do
    changeset = Taxi.create_changeset(%Taxi{}, @valid_attrs)
    assert changeset.valid?
  end

  test "create_changeset/2 with invalid attributes" do
    changeset = Taxi.create_changeset(%Taxi{}, %{})
    refute changeset.valid?
  end

  test "password is required" do
    attrs = %{@valid_attrs | password: ""}
    changeset = Taxi.create_changeset(%Taxi{}, attrs)
    assert %{password: ["can't be blank"]} = errors_on(changeset)
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "johndoe.com"}
    changeset = Taxi.changeset(%Taxi{}, attrs)
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end

  test "email is unique" do
    taxi_existent = insert(:taxi)

    attrs = %{@valid_attrs | email: taxi_existent.email}
    new_taxi = Taxi.changeset(%Taxi{}, attrs)

    assert {:error, changeset} = Repo.insert(new_taxi)
    assert %{email: ["has already been taken"]} = errors_on(changeset)
  end

  test "smtt is unique" do
    taxi_existent = insert(:taxi)

    attrs = %{@valid_attrs | smtt: taxi_existent.smtt}
    new_taxi = Taxi.changeset(%Taxi{}, attrs)

    assert {:error, changeset} = Repo.insert(new_taxi)
    assert %{smtt: ["has already been taken"]} = errors_on(changeset)
  end

  test "email is case insensitive" do
    insert(:taxi, email: "johndoe@voo.com")

    assert %Taxi{} = Repo.get_by(Taxi, email: "johndoe@voo.com")
    assert %Taxi{} = Repo.get_by(Taxi, email: "JOHNDOE@VOO.COM")
  end
end
