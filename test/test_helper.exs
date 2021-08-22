ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(CarbonIntensity.Repo, :manual)
Mox.defmock(CarbonIntensity.HTTP.Mock, for: HTTPoison.Base)
