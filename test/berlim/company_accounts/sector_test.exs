defmodule Berlim.CompanyAccounts.SectorTest do
  use Berlim.DataCase, async: true

  import Berlim.Factory

  alias Berlim.CompanyAccounts.Sector

  test "changeset/2 with valid attributes" do
    changeset = Sector.changeset(%Sector{}, sector_params())
    assert changeset.valid?
  end

  test "changeset/2 with invalid attributes" do
    changeset = Sector.changeset(%Sector{}, %{})
    refute changeset.valid?
  end

  test "changeset/3 with valid attributes" do
    changeset = Sector.changeset(%Sector{}, insert(:company), sector_params())
    assert changeset.valid?
  end

  test "changeset/3 with invalid attributes" do
    changeset = Sector.changeset(%Sector{}, insert(:company), %{})
    refute changeset.valid?
  end

  defp sector_params do
    params_with_assocs(:sector)
  end
end
