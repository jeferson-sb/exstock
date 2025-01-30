defmodule Tracker.WatcherTest do
  use ExUnit.Case
  alias Tracker.Watcher

  test "up" do
    assert Watcher.watch(%{"up" => 100}, 101) == {:up, 100}
  end

  test "down" do
    assert Watcher.watch(%{"down" => 100}, 99) == {:down, 100}
  end

  test "range" do
    assert Watcher.watch(%{"range" => [100, 200]}, 150) == {:range, 100, 200}
  end

  test "percentage up" do
    assert Watcher.watch(%{"percentage_up" => [target: 3, base: 100]}, 103) ==
             {:percentage_up, 3}
  end

  test "percentage down" do
    assert Watcher.watch(%{"percentage_down" => [target: 5, base: 100]}, 95) ==
             {:percentage_down, 5}
  end
end
