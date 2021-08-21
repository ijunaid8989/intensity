import Config

config :c_i,
  ecto_repos: [CarbonIntensity.Repo]

config :c_i, CarbonIntensity.Repo,
  database: "c_i_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
