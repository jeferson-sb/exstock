defmodule Exstock.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      Exstock.Worker,
      Exstock.Scheduler
    ]

    opts = [strategy: :one_for_one]

    Supervisor.init(children, opts)
  end
end
