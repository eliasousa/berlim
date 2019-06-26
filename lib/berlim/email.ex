defmodule Berlim.Email do
  import Bamboo.Email
  import Bamboo.Phoenix

  def welcome_text_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("us@example.com")
    |> subject("Welcome!")
    |> text_body("Welcome to MyApp!")
  end
end
