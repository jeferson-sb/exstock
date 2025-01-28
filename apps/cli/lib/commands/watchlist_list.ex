defmodule Commands.WatchlistList do
  @behaviour Cli.Command

  @impl true
  def execute() do
    Tracker.Watchlist.Repo.all()
  end
end
