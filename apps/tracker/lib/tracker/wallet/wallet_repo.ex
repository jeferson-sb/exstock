defmodule Tracker.Wallet.Repo do
  alias Tracker.Repo

  def create(params) do
    Tracker.Wallet.changeset(%Tracker.Wallet{}, params)
    |> Repo.insert
  end

  def update(wallet, params) do
    wallet
    |> Tracker.Wallet.changeset(params)
    |> Repo.update
  end

  def delete(wallet) do
    Repo.delete(wallet)
  end
end
