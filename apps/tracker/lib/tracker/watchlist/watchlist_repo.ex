defmodule Tracker.Watchlist.Repo do
  alias Tracker.Repo
  import Ecto.Query

  def get_by(params) do
    Tracker.Watchlist
    |> Repo.get_by(params)
  end

  def get_all_by(params) do
    Tracker.Watchlist
    |> where(^params)
    |> Repo.all
  end

  def disable(watchlist) do
    watchlist
    |> Tracker.Watchlist.changeset(%{enabled: false})
    |> Repo.update
  end

  def enable(watchlist) do
    watchlist
    |> Tracker.Watchlist.changeset(%{enabled: true})
    |> Repo.update
  end

  def create(params) do
    Tracker.Watchlist.changeset(%Tracker.Watchlist{}, params)
    |> Repo.insert
  end

  def update(watchlist, params) do
    watchlist
    |> Tracker.Watchlist.changeset(params)
    |> Repo.update
  end

  def delete(watchlist) do
    Repo.delete(watchlist)
  end
end
