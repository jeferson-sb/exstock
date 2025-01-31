defmodule Tracker.Watcher do
  def watch(a, b \\ 0, p)
  def watch(%{"up" => target}, _base, price) when price > target, do: {:up, target}
  def watch(%{"down" => target}, _base, price) when price < target, do: {:down, target}

  def watch(%{"range" => [lower, upper]}, _base, price) when price <= upper and price >= lower,
    do: {:range, lower, upper}

  def watch(%{"percentage_up" => target}, base, price)
      when price >= base + target / 100 * 100,
      do: {:percentage_up, target}

  def watch(%{"percentage_down" => target}, base, price)
      when price <= base - target / 100 * 100,
      do: {:percentage_down, target}

  def watch(_, _, _), do: nil
end
