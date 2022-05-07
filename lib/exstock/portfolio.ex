defmodule Exstock.Wallet do
  defstruct [:id, :name, :assets]
end

defmodule Exstock.Portfolio do
  @static_assets %{AAPL: {:up, 156}, NTFX: {:down, 1000}, AMZN: {:range, 155, 153}}

  @spec start(any) :: nonempty_maybe_improper_list
  def start(state \\ []) do
    # TODO: Remove static content

    add_wallet("my wallet", state)
  end

  def add_wallet(name, state) do
    [%Exstock.Wallet{id: :rand.uniform(), name: name, assets: @static_assets} | state]
  end

  def watch(symbol, price) do
    do_watch(Map.get(@static_assets, String.to_atom(symbol)), price)
    |> Exstock.Alert.add(symbol)
  end

  defp do_watch({:up, target}, price) when price > target, do: {:up, price}
  defp do_watch({:down, target}, price) when price < target, do: {:down, price}

  defp do_watch({:range, upper, lower}, price) when price <= upper and price >= lower,
    do: {:range, price}

  defp do_watch({:percentage_up, target}, price) when price > price * target + price,
    do: {:percentage_up, price}

  defp do_watch({:percentage_down, target}, price) when price < price * target + price,
    do: {:percentage_down, price}

  defp do_watch(_, _), do: nil
end
