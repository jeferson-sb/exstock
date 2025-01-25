defmodule Tracker.Portfolio do
  use Ecto.Schema

  schema "portfolios" do
    field :name, :string
    has_many :wallets, Tracker.Wallet
    has_one :watchlist, Tracker.Watchlist
  end
end
