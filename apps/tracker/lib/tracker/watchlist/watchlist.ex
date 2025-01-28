defmodule Tracker.Watchlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "watchlists" do
    field :symbol, :string
    field :condition, :map
    field :enabled, :boolean, default: true
    belongs_to :portfolio, Tracker.Portfolio
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:symbol, :condition, :enabled, :portfolio_id])
    |> validate_length(:symbol, min: 3)
  end
end
