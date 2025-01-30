defmodule Helpers.DatetimeFormat do
  def format_datetime(datetime) do
    {:ok, dt} = NaiveDateTime.from_erl(datetime)
    Calendar.strftime(dt, "%Y-%m-%d %H:%M:%S %p")
  end
end
