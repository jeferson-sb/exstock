defmodule Commands.WalletList do
  @behaviour Cli.Command

  @impl true
  def execute do
    Tracker.Wallet.Repo.all()
  end
end
