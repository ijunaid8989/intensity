defmodule CarbonIntensity.Repo do
  use Ecto.Repo,
    otp_app: :c_i,
    adapter: Ecto.Adapters.Postgres
end
