defmodule Helpers.HumanFormat do
  def format_human(value) do
    Number.Human.number_to_human(value)
  end
end
