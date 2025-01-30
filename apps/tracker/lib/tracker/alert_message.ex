defmodule Tracker.AlertMessage do
  def message(symbol, {:up, target}) do
    "#{symbol} has crossed up #{format_currency(target)}"
  end

  def message(symbol, {:down, target}) do
    "#{symbol} has crossed down #{format_currency(target)}"
  end

  def message(symbol, {:percentage_up, target}) do
    "#{symbol} is move up #{format_percentage(target)}"
  end

  def message(symbol, {:percentage_down, target}) do
    "#{symbol} is move down #{format_percentage(target)}"
  end

  def message(symbol, {:range, min, max}) do
    "#{symbol} is between #{format_currency(min)} and #{format_currency(max)}"
  end

  defp format_currency(n) do
    Number.Currency.number_to_currency(n)
  end

  defp format_percentage(n) do
    Number.Percentage.number_to_percentage(n, precision: 1)
  end
end
