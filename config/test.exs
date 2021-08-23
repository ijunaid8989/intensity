use Mix.Config

config :c_i, CarbonIntensity.Repo,
  database: "c_i_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :c_i,
  http_adapter: CarbonIntensity.HTTP.Mock

config :c_i,
  worker: false
