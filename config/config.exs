import Config

config :exstock,
  finance_apiurl: "",
  finance_apikey: ""

import_config "#{config_env()}.exs"
