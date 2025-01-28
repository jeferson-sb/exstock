defmodule Commands.PortfolioCreate do
  @behaviour Cli.Command

  @impl true
  def execute(name) do
    Tracker.Portfolio.Repo.create(%{name: name})
  end
end
