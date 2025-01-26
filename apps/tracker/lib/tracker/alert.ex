defmodule Tracker.Alert do
  @name Tracker.Alert
  use GenServer

  def message(symbol, {:up, target}) do
    "#{symbol} has crossed up #{format_currency(target)}"
  end

  def message(symbol, {:down, target}) do
    "#{symbol} has crossed down #{format_currency(target)}"
  end

  def message(symbol, {:percentage_up, target}) do
    "#{symbol} is move up % #{format_currency(target)}"
  end

  def message(symbol, {:percentage_down, target}) do
    "#{symbol} is move down % #{format_currency(target)}"
  end

  def message(symbol, {:range, min, max}) do
    "#{symbol} is between #{format_currency(min)} and #{format_currency(max)}"
  end

  defp format_currency(n) do
    Number.Currency.number_to_currency(n)
  end

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @name)
  end

  def add(condition, symbol) do
    GenServer.cast(@name, {:add, message(symbol, condition)})
  end

  def retrieve() do
    GenServer.call(@name, :retrieve)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:retrieve, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:retrieve, _from, []) do
    {:reply, "No alerts at the moment.", []}
  end

  @impl true
  def handle_cast({:add, alert}, state) do
    {:noreply, [alert | state]}
  end

  @impl true
  def handle_info(:data, state) do
    {:noreply, state}
  end
end
