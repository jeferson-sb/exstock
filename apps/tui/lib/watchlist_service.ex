defmodule Watchlist.Service do
  def execute do
    Tracker.Watchlist.Repo.get_all_by(enabled: true)
    |> Enum.map(fn watchlist ->
      {:ok, data} = Tracker.Query.get_latest_symbol(watchlist.symbol)
      %{"high" => high, "low" => low, "close" => close} = data
      Map.put(watchlist, :values, {high, low, close})
    end)
  end
end
