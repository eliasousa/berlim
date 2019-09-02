alias Berlim.{
  CompanyAccounts,
  InternalAccounts,
  Vouchers
}

InternalAccounts.create_admin(%{
  email: "admin@voo.com",
  active: true,
  name: "Admin",
  password: "123456",
  phone: "79999445849"
})

taxi_data = [
  %{
    email: "taxi_10@voo.com",
    active: true,
    smtt: 10,
    password: "123456",
    cpf: "00100100100",
    phone: "79999445849"
  },
  %{
    email: "taxi_20@voo.com",
    active: true,
    smtt: 20,
    password: "123456",
    cpf: "00100100101",
    phone: "79999445849"
  },
  %{
    email: "taxi_30@voo.com",
    active: true,
    smtt: 30,
    password: "123456",
    cpf: "00100100102",
    phone: "79999445849"
  }
]

Enum.each(taxi_data, fn data ->
  InternalAccounts.create_taxi(data)
end)

company_data = [
  %{
    email: "admin@jaya.tech",
    active: true,
    name: "Jaya",
    password: "123456",
    cnpj: "0000010001000101",
    phone: "79999445849"
  },
  %{
    email: "admin@github.com",
    active: true,
    name: "Github",
    password: "123456",
    cnpj: "0000010001000102",
    phone: "79999445849"
  },
  %{
    email: "admin@nubank.com",
    active: true,
    name: "Nubank",
    password: "123456",
    cnpj: "0000010001000103",
    phone: "79999445849"
  }
]

sector_data = [
  %{name: "RH"},
  %{name: "Administrativo"},
  %{name: "Financeiro"}
]

Enum.each(company_data, fn data ->
  {:ok, company} = CompanyAccounts.create_company(data)

  Enum.each(sector_data, fn data ->
    CompanyAccounts.create_sector(company, data)
  end)

  company_name = String.downcase(company.name)

  {:ok, employee_1} =
    CompanyAccounts.create_employee(company, %{
      name: "#{company.name} Employee 1",
      internal_id: "1234",
      email: "#{company_name}_employee_1@#{company_name}.com",
      active: true,
      password: "123456"
    })

  {:ok, employee_2} =
    CompanyAccounts.create_employee(company, %{
      name: "#{company.name} Employee 2",
      internal_id: "1234",
      email: "#{company_name}_employee_2@#{company_name}.com",
      active: true,
      password: "123456"
    })

  employee_list = [employee_1.id, employee_2.id]
  from_list = ["Casa", "Trabalho", "Escola"]
  to_list = ["Shopping", "Parque", "Feira"]

  1..20
  |> Enum.each(fn _ ->
    Vouchers.create_voucher(%{
      from: Enum.random(from_list),
      to: Enum.random(to_list),
      value: Enum.random(10..100),
      employee_id: Enum.random(employee_list),
      taxi_id: Enum.random(1..3),
      note: "Sample Note"
    })
  end)
end)
