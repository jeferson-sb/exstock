defmodule Tracker.MixProject do
  use Mix.Project

  def project do
    [
      app: :tracker,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Tracker.Application, []},
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:number, "~> 1.0.1"},
      {:ecto_sqlite3, "~> 0.17"},
      {:igniter, "~> 0.5"},
      {:oban, "~> 2.18"}
    ]
  end
end
