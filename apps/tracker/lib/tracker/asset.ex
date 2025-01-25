defmodule Tracker.Asset do
  use Ecto.Schema

  schema "assets" do
    field :name, :string
    field :symbol, :string
    belongs_to :wallet, Tracker.Wallet
  end
end
