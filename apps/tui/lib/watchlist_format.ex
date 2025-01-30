defmodule Helpers.Watchlist do
  def format_currency(n), do: Number.Currency.number_to_currency(n)

  def format_condition(%{"up" => price}), do: "Up to #{format_currency(price)}"
  def format_condition(%{"down" => price}), do: "Down to #{format_currency(price)}"

  def format_condition(%{"range" => [min, max]}),
    do: "Between #{format_currency(min)} and #{format_currency(max)}"

  def format_condition(%{"percentage_up" => percent}), do: "Up #{percent}%"
  def format_condition(%{"percentage_down" => percent}), do: "Down #{percent}%"
  def format_condition(condition), do: condition

  def format_enabled(true), do: "yes"
  def format_enabled(false), do: "no"
end
