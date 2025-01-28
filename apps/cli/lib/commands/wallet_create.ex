defmodule Commands.WalletCreate do
  @behaviour Cli.Command

  @impl true
  def execute(name, assets, portfolio_id) do
    Tracker.Repo.transaction(fn ->
      {:ok, wallet} = Tracker.Wallet.Repo.create(%{name: name, portfolio_id: portfolio_id})

      assets
      |> String.split(",")
      |> Enum.each(fn asset ->
        Tracker.Asset.Repo.create(%{name: asset, symbol: asset, wallet_id: wallet.id})
      end)
    end)
  end
end
