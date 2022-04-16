defmodule Exstock.Scheduler do
  use GenServer

  @ten_minutes 10 * 60 * 1000

  def start_link(opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def quote(symbol, recurring_at \\ @ten_minutes) do
    GenServer.cast(__MODULE__, {:symbol, symbol, :timing, recurring_at})
  end

  def lookup_quote(symbol) do
    GenServer.call(__MODULE__, {:lookup, symbol})
  end

  def cancel do
    GenServer.stop(__MODULE__)
  end

  @impl true
  def init(:ok) do
    {:ok, %{last_run_at: nil}}
  end

  @impl true
  def handle_cast({:symbol, symbol, :timing, timing}, _state) do
    {:ok, data} = Exstock.Query.quote(symbol)
    Process.send_after(self(), :tick, timing)

    {:noreply, %{last_run_at: :calendar.local_time(), data: data}}
  end

  @impl true
  def handle_call({:lookup, symbol}, _from, state) do
    {:reply, symbol, state}
  end

  @impl true
  def handle_info(:tick, state) do
    # TODO: Trigger notification/alert
    IO.inspect(state)
    {:noreply, state}
  end
end