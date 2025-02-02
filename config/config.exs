import Config

config :tracker, Oban,
  engine: Oban.Engines.Lite,
  notifier: Oban.Notifiers.PG,
  queues: [default: 10],
  repo: Tracker.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"*/30 9-17 * * *", Tracker.PeriodicWatcher}
     ]}
  ]

config :tracker, Tracker.Repo,
  database: "./database.db",
  log: false

config :tracker,
  primary_finance_api_url: "",
  primary_finance_api_key: "",
  secondary_finance_api_url: "",
  secondary_finance_api_key: "",
  resend_api_key: "",
  user_email: "",
  ecto_repos: [Tracker.Repo]

import_config "#{config_env()}.exs"
