use Mix.Config

config :c_i, CarbonIntensity.Repo,
  database: "c_i_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :c_i,
  http_adapter: HTTPoison

config :c_i,
  worker: true
