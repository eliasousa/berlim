defmodule Berlim.ParseHelpersTest do
  @moduledoc false

  use Berlim.DataCase

  alias Berlim.ParseHelpers

  test "parse_date/1 with valid DD/MM/YYYY date" do
    assert ParseHelpers.parse_date("25/10/2010") == ~N[2010-10-25 00:00:00]
  end

  test "parse_date/1 with empty date" do
    assert is_nil(ParseHelpers.parse_date(""))
  end
end
