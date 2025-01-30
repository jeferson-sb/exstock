defmodule Tracker.AlertMessage.Test do
  use ExUnit.Case
  alias Tracker.AlertMessage
  doctest Tracker.AlertMessage

  test "up" do
    assert AlertMessage.message("AAPL", {:up, 100}) == "AAPL has crossed up $100.00"
  end

  test "down" do
    assert AlertMessage.message("AAPL", {:down, 100}) == "AAPL has crossed down $100.00"
  end

  test "range" do
    assert AlertMessage.message("AAPL", {:range, 100, 200}) ==
             "AAPL is between $100.00 and $200.00"
  end

  test "percentage up" do
    assert AlertMessage.message("AAPL", {:percentage_up, 3}) == "AAPL is move up 3.0%"
  end

  test "percentage down" do
    assert AlertMessage.message("AAPL", {:percentage_down, 5}) == "AAPL is move down 5.0%"
  end
end
