defmodule Watchlist.Service do
  def execute do
    Tracker.Watchlist.Repo.get_all_by(enabled: true)
    |> Enum.reduce_while([], fn watchlist, acc ->
      case Tracker.Query.get_latest_symbol(watchlist.symbol) do
        {:ok, %{"high" => high, "low" => low, "close" => close}} ->
          updated = Map.put(watchlist, :values, {high, low, close})
          {:cont, [updated | acc]}

        {:error, reason} ->
          {:halt, {:error, reason}}
      end
    end)
    |> case do
      {:error, reason} -> {:error, reason}
      results -> Enum.reverse(results)
    end
  end
end
