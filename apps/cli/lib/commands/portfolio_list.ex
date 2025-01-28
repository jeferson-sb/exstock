defmodule Commands.PortfolioList do
  @behaviour Cli.Command

  @impl true
  def execute do
    Tracker.Portfolio.Repo.all()
  end
end
