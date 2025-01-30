defmodule Tracker.Asset do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assets" do
    field(:name, :string)
    field(:symbol, :string)
    belongs_to(:wallet, Tracker.Wallet)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :symbol, :wallet_id])
    |> validate_required([:name, :symbol, :wallet_id])
  end
end
