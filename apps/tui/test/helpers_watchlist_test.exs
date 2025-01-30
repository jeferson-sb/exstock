defmodule Helpers.Watchlist.Test do
  use ExUnit.Case
  alias Helpers.Watchlist

  test "format_condition/1" do
    assert Watchlist.format_condition(%{"up" => 100}) == "Up to $100.00"
    assert Watchlist.format_condition(%{"down" => 100}) == "Down to $100.00"
    assert Watchlist.format_condition(%{"range" => [100, 200]}) == "Between $100.00 and $200.00"
    assert Watchlist.format_condition(%{"percentage_up" => 10}) == "Up 10%"
    assert Watchlist.format_condition(%{"percentage_down" => 10}) == "Down 10%"
  end

  test "format_enabled/1" do
    assert Watchlist.format_enabled(true) == "yes"
    assert Watchlist.format_enabled(false) == "no"
  end
end
