defmodule Exstock.Alert do
  @moduledoc """
    Add alerts to schedule a query in a specific time then pop this alert back to user
  """

  @name MyAlert
  use GenServer

  def message(symbol, {:up, target}) do
    "#{symbol} has crossed up #{Number.Currency.number_to_currency(target)}"
  end

  def message(symbol, {:down, target}) do
    "#{symbol} has crossed down #{Number.Currency.number_to_currency(target)}"
  end

  def message(symbol, {:percentage_up, target}) do
    "#{symbol} is move up % #{Number.Currency.number_to_currency(target)}"
  end

  def message(symbol, {:percentage_down, target}) do
    "#{symbol} is move down % #{Number.Currency.number_to_currency(target)}"
  end

  def message(symbol, {:range, target}) do
    "#{symbol} is between in the range #{Number.Currency.number_to_currency(target)}"
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
