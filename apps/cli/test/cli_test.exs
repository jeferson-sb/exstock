defmodule CliTest do
  use ExUnit.Case
  import Cli, only: [parse_args: 1]

  doctest Cli

  test ":help returned by option parsing with -h and --help" do
    assert parse_args(["-h"]) == :help
    assert parse_args(["--help"]) == :help
  end
end
