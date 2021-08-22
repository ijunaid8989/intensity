import Config

config :c_i,
  ecto_repos: [CarbonIntensity.Repo]

config :c_i,
  http_adapter: HTTPoison

import_config "#{Mix.env()}.exs"
