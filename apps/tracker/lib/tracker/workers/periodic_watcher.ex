defmodule Tracker.PeriodicWatcher do
  use Oban.Worker
  require Logger

  @impl Oban.Worker
  def perform(job) do
    Tracker.Watchlist.Repo.get_all_by(enabled: true)
    |> Enum.reduce([], fn watchlist, acc ->
      Logger.info("Checking watchlist: #{watchlist.symbol}")

      case Tracker.Watcher.watch(
             watchlist.condition,
             watchlist.base_price,
             get_hot_price(watchlist.symbol)
           ) do
        nil -> acc
        result -> [{watchlist.symbol, result} | acc]
      end
    end)
    |> Enum.map(fn {symbol, condition} ->
      Tracker.AlertMessage.message(symbol, condition)
    end)
    |> Tracker.Mailers.WatcherMailer.mail

    {:ok, job}
  end

  defp get_hot_price(symbol) do
    {:ok, response} = Tracker.Query.get_latest_symbol(symbol)
    %{"close" => price} = response
    {value, _} = Float.parse(price)
    value
  end
end
