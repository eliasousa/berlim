defmodule Berlim.CompanyAccounts.SectorTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.CompanyAccounts.Sector

  test "changeset with valid attributes" do
    changeset = Sector.changeset(%Sector{}, sector_params())
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Sector.changeset(%Sector{}, %{})
    refute changeset.valid?
  end

  test "company does not exist" do
    attrs = %{sector_params() | company_id: 0}
    sector = Sector.changeset(%Sector{}, attrs)

    assert {:error, changeset} = Repo.insert(sector)
    assert %{company: ["does not exist"]} = errors_on(changeset)
  end

  test "company is required" do
    changeset = Sector.changeset(%Sector{}, params_for(:sector))
    assert %{company: ["can't be blank"]} = errors_on(changeset)
  end

  defp sector_params do
    params_with_assocs(:sector)
  end
end
