defmodule Tracker.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :name, :string
    belongs_to :portfolio, Tracker.Portfolio
    has_many :assets, Tracker.Asset, on_delete: :delete_all
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :portfolio_id])
    |> validate_required([:name, :portfolio_id])
  end
end
