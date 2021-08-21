use Mix.Config

config :c_i, CarbonIntensity.Repo,
  database: "c_i_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
