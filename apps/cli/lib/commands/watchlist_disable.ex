defmodule Commands.WatchlistDisable do
  @behaviour Cli.Command

  @impl true
  def execute(watchlist) do
    Tracker.Watchlist.Repo.disable(watchlist)
  end
end
