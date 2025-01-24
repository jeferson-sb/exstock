import Config

config :tracker, Oban,
  engine: Oban.Engines.Lite,
  notifier: Oban.Notifiers.PG,
  queues: [default: 10],
  repo: Tracker.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"*/30 9-17 * * *", Tracker.PeriodicWatcher},
     ]}
  ]

config :tracker, Tracker.Repo,
  database: "./database.db"

config :tracker,
  finance_apiurl: "",
  finance_apikey: "",
  ecto_repos: [Tracker.Repo]

import_config "#{config_env()}.exs"
