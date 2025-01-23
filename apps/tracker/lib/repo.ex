defmodule Tracker.Repo do
  use Ecto.Repo, otp_app: :tracker, adapter: Ecto.Adapters.SQLite3
end
