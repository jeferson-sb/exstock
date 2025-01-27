defmodule Tracker.Watcher do
  def watch(%{"up" => target}, price) when price > target, do: {:up, target}
  def watch(%{"down" => target}, price) when price < target, do: {:down, target}
  def watch(%{"range" => [upper, lower]}, price) when price <= upper and price >= lower,
    do: {:range, lower, upper}

  def watch(%{"percentage_up" => target}, price) when price > price * target + price,
    do: {:percentage_up, target}

  def watch(%{"percentage_down" => target}, price) when price < price * target + price,
    do: {:percentage_down, target}

  def watch(_, _), do: nil
end
