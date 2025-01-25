defmodule Tracker.Repo.Migrations.AddAsset do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string
      add :symbol, :string
      add :wallet_id, references(:wallets)
    end
  end
end
