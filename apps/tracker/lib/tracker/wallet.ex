defmodule Tracker.Wallet do
  use Ecto.Schema

  schema "wallets" do
    field :name, :string
    belongs_to :portfolio, Tracker.Portfolio
    has_many :assets, Tracker.Asset
  end
end
