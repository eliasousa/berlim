defmodule Berlim.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add(:fullname, :string, null: false)
      add(:email, :string, null: false)
      add(:phone, :string, null: false)
      add(:address_street, :string, null: false)
      add(:address_street_number, :string, null: false)
      add(:address_complement, :string, null: false)
      add(:address_city_code, :integer, null: false)
      add(:address_city_name, :string, null: false)
      add(:address_state, :string, null: false)
      add(:address_zipcode, :string, null: false)
      add(:address_district, :string, null: false)
      add(:address_country, :string, null: false)

      timestamps()
    end
  end
end
