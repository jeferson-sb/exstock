defmodule Tracker.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field :name, :string
    belongs_to :portfolio, Tracker.Portfolio
    has_many :assets, Tracker.Asset
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
