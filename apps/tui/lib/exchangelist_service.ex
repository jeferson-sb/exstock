defmodule ExchangeList.Service do
  def execute do
    # TODO: remove hardcoded list
    exchanges = [["USD", "BRL"], ["USD", "EUR"], ["USD", "JPY"], ["BRL", "JPY"]]

    Enum.reduce_while(exchanges, [], fn [from, to], acc ->
      case get_exchange_rate(from, to) do
        {:error, reason} ->
          {:halt, {:error, reason}}

        rate ->
          {:cont, [rate | acc]}
      end
    end)
    |> case do
      {:error, reason} -> {:error, reason}
      rates -> Enum.reverse(rates)
    end
  end

  defp get_exchange_rate(from, to) do
    Tracker.Query.get_exchange_rate(from, to)
    |> case do
      {:ok, rate} -> rate
      {:error, reason} -> {:error, reason}
    end
  end
end
