defmodule Tracker.PeriodicWatcher do
  use Oban.Worker
  alias Tracker.Repo
  require Logger
  import Ecto.Query

  @impl Oban.Worker
  def perform(job) do
    Tracker.Watchlist
    |> where(enabled: true)
    |> Repo.all
    |> Enum.reduce([], fn watchlist, acc ->
      Logger.info("Checking watchlist: #{watchlist.symbol}")
      case Tracker.Watcher.watch(watchlist.condition, get_hot_price(watchlist.symbol)) do
        nil -> acc
        result -> [{watchlist.symbol, result} | acc]
      end
    end)
    |> Enum.map(fn {symbol, condition} ->
      Tracker.Alert.message(symbol, condition)
    end)
    |> IO.inspect # TODO: remove in favor or notification system triggering

    {:ok, job}
  end

  defp get_hot_price(symbol) do
    {:ok, response} = Tracker.Query.get_latest_symbol(symbol)
    %{"close" => price} = response
    {value, _} = Float.parse(price)
    value
  end
end
