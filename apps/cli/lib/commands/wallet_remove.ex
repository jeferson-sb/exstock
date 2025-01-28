defmodule Commands.WalletRemove do
  @behaviour Cli.Command

  @impl true
  def execute(wallet) do
    Tracker.Wallet.Repo.delete(wallet)
  end
end
