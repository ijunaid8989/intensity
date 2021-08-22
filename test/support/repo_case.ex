defmodule CarbonIntensity.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias CarbonIntensity.{Intensity, Repo}
      alias Ecto.Changeset

      import Ecto
      import Ecto.Query
      import CarbonIntensity.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CarbonIntensity.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CarbonIntensity.Repo, {:shared, self()})
    end

    :ok
  end
end
