defmodule Exstock.Worker do
  @name MyWorker

  use GenServer

  # Client GenServer calls

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: @name)
  end

  def add_quote(symbol) do
    GenServer.cast(@name, {:symbol, symbol})
  end

  def get_quote() do
    GenServer.call(@name, :get)
  end

  # API Callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, [head | tail]) do
    {:reply, [head | tail], tail}
  end

  @impl true
  def handle_cast({:symbol, symbol}, state) do
    case Exstock.Query.quote(symbol) do
      {:ok, data} ->
        {:noreply, [data | state]}

      _ ->
        {:noreply, :error, state}
    end
  end

  @impl true
  def handle_info(:work, state) do
    state
  end

  @impl true
  def terminate(reason, state) do
    IO.puts("Reason: #{inspect(reason)}; State: #{inspect(state)}")
  end
end
