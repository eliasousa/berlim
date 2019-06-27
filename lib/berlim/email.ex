defmodule Berlim.Email do
  @moduledoc false

  import Swoosh.Email

  def welcome(email, username, password) do
    base_email()
    |> to({"", email})
    |> put_provider_option(:template_id, "d-8583f55b7332474ab864a9372d48c04f")
    |> put_provider_option(:dynamic_template_data, %{username: username, password: password})
  end

  defp base_email do
    new()
    |> from({"Voo de Taxi", "naoresponda@voodetaxi.com.br"})
    |> text_body("nil")
  end
end
