defmodule Cli do
  def main(args) do
    args |> parse_args() |> process()
  end

  defp process(:help) do
    IO.puts """
    Usage:
      portfolio:create - Create a portfolio
      wallet:create - Create a wallet and assets
      watchlist:list - List watchlists
      watchlist:add - Add a watchlist
      watchlist:disable - Disable a watchlist for being tracked
    """
    # System.halt(0)
  end

  defp process([portfolio: :create]) do
    name = Prompt.text("What's your portfolio name")
    Commands.PortfolioCreate.execute(name)

    Prompt.display "\n'#{name}' successfully created!", [color: :green]
    Prompt.display "You might want to add a wallet to it and add some assets too", [color: :green]
  end

  defp process([wallet: :create]) do
    name = Prompt.text("What's your wallet name")
    portfolios = Commands.PortfolioList.execute |> Enum.map(fn p -> {p.name, p.id} end)
    portfolio_id = Prompt.select("Select a portfolio", portfolios)
    assets = Prompt.text("Enter the assets you want to add separated by comma")
    Commands.WalletCreate.execute(name, assets, portfolio_id)

    Prompt.display "\n'#{name}' successfully created!", [color: :green]
  end

  defp process([watchlist: :list]) do
    Prompt.display "Listing watchlists...", [color: :yellow]
    Commands.WatchlistList.execute()
    |> Helpers.WatchlistTable.format()
  end

  defp process([watchlist: :add]) do
    portfolios = Commands.PortfolioList.execute() |> Enum.map(fn p -> {p.name, p.id} end)
    portfolio_id = Prompt.select("Select a portfolio", portfolios)
    symbol = Prompt.text("Enter the symbol")
    condition = Prompt.text("Enter the condition (e.g. up 100, down 100, range 100 200, percentage_up 10, percentage_down 10)")
    args = [symbol: symbol, condition: condition, portfolio_id: portfolio_id]

    case Commands.WatchlistAdd.execute(args) do
      {:ok, _} ->
        Prompt.display "\nWatchlist for '#{symbol}' successfully created!", [color: :green]
      {:error, changeset} ->
        Prompt.display "\nError creating watchlist: #{changeset.errors}", [color: :red]
    end
  end

  defp process([watchlist: :disable]) do
  end

  defp parse_args(args) do
    parse =
      OptionParser.parse(args,
        switches: [help: :boolean],
        aliases: [h: :help]
      )

    case parse do
      { [help: true], _, _ } ->
        :help
      { _, ["portfolio:create"], _, } -> [portfolio: :create]
      { _, ["wallet:create"], _, } -> [wallet: :create]
      { _, ["watchlist:list"], _, } -> [watchlist: :list]
      { _, ["watchlist:add"], _, } -> [watchlist: :add]
      { _, ["watchlist:disable"], _, } -> [watchlist: :disable]
      _ ->
        :help
    end
  end
end
