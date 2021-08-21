import Config

config :c_i,
  ecto_repos: [CarbonIntensity.Repo]

import_config "#{Mix.env()}.exs"
