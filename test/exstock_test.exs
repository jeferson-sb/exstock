defmodule ExstockTest do
  use ExUnit.Case
  doctest Exstock

  test "greets the world" do
    assert Exstock.hello() == :world
  end
end
