defmodule Commands.WatchlistAdd do
  @behaviour Cli.Command

  @impl true
  def execute([symbol: symbol, condition: condition, portfolio_id: portfolio_id]) do
    [left, right] = condition |> String.trim |> String.split(" ")
    Tracker.Watchlist.Repo.create(%{symbol: symbol, condition: %{String.to_atom(left) => right}, portfolio_id: portfolio_id})
  end
end
