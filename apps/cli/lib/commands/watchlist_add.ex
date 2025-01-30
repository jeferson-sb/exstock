defmodule Commands.WatchlistAdd do
  @behaviour Cli.Command

  @impl true
  def execute([symbol: symbol, condition: condition, portfolio_id: portfolio_id]) do
    condition = condition |> String.trim |> String.split(" ") |> parse_condition
    Tracker.Watchlist.Repo.create(%{symbol: symbol, condition: condition, portfolio_id: portfolio_id})
  end

  def parse_condition([left, right]) do
    %{String.to_atom(left) => right}
  end

  def parse_condition([left | right]) do
    parse_condition([left, right])
  end
end
