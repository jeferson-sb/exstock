defmodule TuiTest do
  use ExUnit.Case
  doctest Tui

  test "greets the world" do
    assert Tui.hello() == :world
  end
end
