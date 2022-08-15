import Config

config :exstock,
  finance_apiurl: "",
  finance_apikey: "",
  ecto_repos: [Exstock.Repo]

config :exstock, Exstock.Repo, database: "database.db"

import_config "#{config_env()}.exs"
