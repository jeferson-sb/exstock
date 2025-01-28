defmodule Helpers.WalletTable do
  def format(wallets) do
    table = wallets
    |> Stream.map(&format_row/1)
    |> Enum.to_list

    Enum.concat([
      ["ID", "NAME", "PORTFOLIO", "ASSETS COUNT"],
      ["--", "--", "--", "--"],
    ], table)
    |> Prompt.table
  end

  def format_row(wallet) when is_nil(wallet.portfolio) do
    [
      Integer.to_string(wallet.id),
      wallet.name,
      "n/a",
      Integer.to_string(wallet.assets |> length)
    ]
  end

  def format_row(wallet) do
    [
      Integer.to_string(wallet.id),
      wallet.name,
      wallet.portfolio.name,
      Integer.to_string(wallet.assets |> length)
    ]
  end
end
