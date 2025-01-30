defmodule Helpers.HumanFormat do
  import Number.Human

  def format_human(value) do
    number_to_human(value)
  end
end
