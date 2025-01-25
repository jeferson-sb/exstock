defmodule Tracker.Repo.Migrations.AddWallet do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :name, :string
      add :portfolio_id, references(:portfolios)
    end
  end
end
