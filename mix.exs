defmodule Exstock.MixProject do
  use Mix.Project

  def project do
    [
      app: :exstock,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8.0"},
      {:json, "~> 1.4"},
      {:ratatouille, "~> 0.5.0"},
      {:number, "~> 1.0.1"},
      {:ecto_sqlite3, "~> 0.7.4"}
    ]
  end
end
