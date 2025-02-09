defmodule Exstock.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        cli: [
          applications: [
            cli: :permanent,
            tracker: :permanent,
          ]
        ],
        tracker: [
          applications: [tracker: :permanent]
        ],
        tui: [
          applications: [tui: :permanent]
        ],
      ]
    ]
  end

  defp deps do
    []
  end
end
