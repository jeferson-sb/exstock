defmodule Tracker.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Tracker.Repo,
      {Oban, Application.fetch_env!(:Tracker, Oban)}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
