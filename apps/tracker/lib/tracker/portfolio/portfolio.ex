defmodule Tracker.Portfolio do
  use Ecto.Schema
  import Ecto.Changeset

  schema "portfolios" do
    field(:name, :string)
    has_many(:wallets, Tracker.Wallet)
    has_one(:watchlist, Tracker.Watchlist)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
