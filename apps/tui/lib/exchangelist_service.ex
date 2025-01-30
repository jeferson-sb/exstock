defmodule ExchangeList.Service do
  def execute do
    # TODO: remove hardcoded list
    exchanges = [["USD", "BRL"], ["USD", "EUR"], ["USD", "JPY"]]
    Enum.map(exchanges, fn exchange ->
      [from, to] = exchange
      {:ok, rate} = Tracker.Query.get_exchange_rate(from, to)
      rate
    end)
  end
end
