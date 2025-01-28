defmodule Helpers.WatchlistTable do
  def format(watchlists) do
    table = watchlists
    |> Enum.map(fn watchlist ->
      [
        watchlist.symbol,
        format_condition(watchlist.condition),
        format_enabled(watchlist.enabled)
      ]
    end)

    Prompt.table([
      ["SYMBOL", "CONDITION", "ENABLED"],
      ["--", "--", "--"],
      List.flatten(table)
    ])
  end

  defp format_currency(n), do: Number.Currency.number_to_currency(n)

  defp format_condition(%{"up" => price}), do: "Up to #{format_currency(price)}"
  defp format_condition(%{"down" => price}), do: "Down to #{format_currency(price)}"
  defp format_condition(%{"range" => [min, max]}), do: "Between #{format_currency(min)} and #{format_currency(max)}"
  defp format_condition(%{"percentage_up" => percent}), do: "Up #{percent}%"
  defp format_condition(%{"percentage_down" => percent}), do: "Down #{percent}%"
  defp format_condition(condition), do: condition

  defp format_enabled(true), do: "yes"
  defp format_enabled(false), do: "no"
end
