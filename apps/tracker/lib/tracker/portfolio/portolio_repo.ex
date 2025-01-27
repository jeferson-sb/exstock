defmodule Tracker.Portfolio.Repo do
  alias Tracker.Repo

  def create(params) do
    Tracker.Portfolio.changeset(%Tracker.Portfolio{}, params)
    |> Repo.insert
  end

  def update(portfolio, params) do
    portfolio
    |> Tracker.Portfolio.changeset(params)
    |> Repo.update
  end

  def delete(portfolio) do
    Repo.delete(portfolio)
  end
end
