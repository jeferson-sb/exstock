defmodule Helpers.NumberFormat do
  import Number.Currency

  def format_currency(value) do
    number_to_currency(value)
  end
end
