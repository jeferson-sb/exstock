defmodule Tracker.Asset.Repo do
  alias Tracker.Repo

  def create(params) do
    Tracker.Asset.changeset(%Tracker.Asset{}, params)
    |> Repo.insert
  end

  def update(asset, params) do
    asset
    |> Tracker.Asset.changeset(params)
    |> Repo.update
  end

  def delete(asset) do
    Repo.delete(asset)
  end
end
