import Config

config :tracker, Oban,
  engine: Oban.Engines.Lite,
  notifier: Oban.Notifiers.PG,
  queues: [default: 10],
  repo: Tracker.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"* * * * *", Tracker.PeriodicWatcher, queue: :scheduled},
     ]}
  ]

config :tracker,
  finance_apiurl: "",
  finance_apikey: "",
  ecto_repos: [Tracker.Repo]

config :tracker, Tracker.Repo, database: "database.db"

import_config "#{config_env()}.exs"
