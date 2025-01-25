defmodule Tracker.Repo.Migrations.AddPortfolio do
  use Ecto.Migration

  def change do
    create table(:portfolios) do
      add :name, :string
    end
  end
end
