defmodule Tracker.Repo.Migrations.AddWatchlist do
  use Ecto.Migration

  def change do
    create table(:watchlists) do
      add :symbol, :string
      add :condition, :map
      add :enabled, :boolean, default: true
      add :portfolio_id, references(:portfolios)
    end
  end
end
