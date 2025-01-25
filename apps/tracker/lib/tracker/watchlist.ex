defmodule Tracker.Watchlist do
  use Ecto.Schema

  schema "watchlists" do
    field :symbol, :string
    field :condition, :map
    field :enabled, :boolean, default: true
    belongs_to :portfolio, Tracker.Portfolio
  end
end
