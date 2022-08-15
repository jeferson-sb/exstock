defmodule Exstock.Repo do
  use Ecto.Repo, otp_app: :exstock, adapter: Ecto.Adapters.SQLite3
end
