defmodule Tracker.Application do
  require Logger
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Logger.debug("Starting Tracker")

    children = [
      Tracker.Repo,
      {Oban, Application.fetch_env!(:tracker, Oban)}
    ]

    opts = [strategy: :one_for_one, name: Tracker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
