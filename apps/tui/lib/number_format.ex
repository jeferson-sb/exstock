defmodule Helpers.NumberFormat do
  def format_currency(value) do
    Number.Currency.number_to_currency(value)
  end
end
