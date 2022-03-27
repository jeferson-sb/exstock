defmodule Exstock.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  @impl true
  def init(_) do
    children = [
      Exstock.Worker
    ]

    opts = [strategy: :one_for_one]

    Supervisor.init(children, opts)
  end
end
