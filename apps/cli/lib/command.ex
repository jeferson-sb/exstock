defmodule Cli.Command do
  @callback execute(... :: any()) :: any()
  @callback execute() :: any()
  @optional_callbacks execute: 1, execute: 0
end
