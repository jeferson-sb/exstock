defmodule Tracker.PeriodicWatcher do
  use Oban.Worker
  require Logger

  @impl Oban.Worker
  def perform(job) do
    wl =
    Tracker.Watchlist.Repo.get_all_by(enabled: true)
    |> evaluate_watcher

    wl
    |> Enum.map(fn {_, symbol, condition} ->
      Tracker.AlertMessage.message(symbol, condition)
    end)
    |> Enum.join("\n")
    |> Tracker.Mailers.WatcherMailer.mail

    wl |> disable_watchers

    {:ok, job}
  end

  defp disable_watchers(watchlist) do
    watchlist
    |> Enum.each(fn {wl, _, _} -> Tracker.Watchlist.Repo.disable(wl) end)
  end

  defp evaluate_watcher(wl) do
    wl
    |> Enum.reduce([], fn watchlist, acc ->
      Logger.info("Checking watchlist: #{watchlist.symbol}")

      case Tracker.Watcher.watch(
             watchlist.condition,
             watchlist.base_price,
             get_hot_price(watchlist.symbol)
           ) do
        nil -> acc
        result -> [{watchlist, watchlist.symbol, result} | acc]
      end
    end)
  end

  defp get_hot_price(symbol) do
    {:ok, response} = Tracker.Query.get_latest_symbol(symbol)
    %{"close" => price} = response
    {value, _} = Float.parse(price)
    value
  end
end
