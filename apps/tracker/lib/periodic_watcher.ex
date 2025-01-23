defmodule Tracker.PeriodicWatcher do
  use Oban.Worker

  @impl Oban.Worker
  def perform(job) do
    IO.puts("Done!")
    {:ok, job}
  end
end
