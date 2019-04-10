defmodule BerlimWeb.Plugs.Helpers.RequireAuthHelper do
  @moduledoc """
  The require auth Helper.
  """
  import Plug.Conn, only: [put_status: 2]

  use Phoenix.Controller

  alias Berlim.{
    CompanyAccounts.Company,
    Guardian,
    InternalAccounts.Admin
  }

  defmacro __using__(_) do
    quote do
      import BerlimWeb.Plugs.Helpers.RequireAuthHelper
    end
  end

  def check_user_auth(:admin, conn) do
    case Guardian.Plug.current_resource(conn) do
      %Admin{} = admin ->
        assign(conn, :admin, admin)

      _ ->
        error_return_and_halt(conn)
    end
  end

  def check_user_auth(:company, conn) do
    case Guardian.Plug.current_resource(conn) do
      %Company{} = company ->
        assign(conn, :company, company)

      _ ->
        error_return_and_halt(conn)
    end
  end

  defp error_return_and_halt(conn) do
    conn
    |> put_status(403)
    |> json(%{error: "Você não pode acessar esse recurso"})
    |> halt()
  end
end
