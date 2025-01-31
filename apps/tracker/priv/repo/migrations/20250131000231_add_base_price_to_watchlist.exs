defmodule Tracker.Repo.Migrations.AddBasePriceToWatchlist do
  use Ecto.Migration

  def change do
    alter table(:watchlists) do
      add(:base_price, :float)
    end
  end
end
