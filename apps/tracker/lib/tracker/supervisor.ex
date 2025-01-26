defmodule Tracker.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    Logger.debug("Starting Supervisor")

    children = [
      Tracker.Alert
    ]

    opts = [strategy: :one_for_one]

    Supervisor.init(children, opts)
  end
end
