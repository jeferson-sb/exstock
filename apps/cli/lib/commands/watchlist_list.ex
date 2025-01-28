defmodule Commands.WatchlistList do
  @behaviour Cli.Command

  @impl true
  def execute() do
    Tracker.Watchlist.Repo.all()
  end

  def execute(params) do
    Tracker.Watchlist.Repo.get_all_by(params)
  end
end
