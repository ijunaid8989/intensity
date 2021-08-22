defmodule CarbonIntensity.Intensity do
  use Ecto.Schema

  alias CarbonIntensity.{Intensity, Repo}

  import Ecto.Changeset

  @required [:datetime, :intensity]

  schema "intensity" do
    field(:datetime, :string)
    field(:intensity, :integer)
  end

  def add(params, opts \\ []) do
    %Intensity{}
    |> changeset(params)
    |> Repo.insert(opts)
  end

  def changeset(%Intensity{} = struct, params \\ %{}) do
    struct
    |> cast(params, @required)
    |> validate_required(@required)
    |> unique_constraint(
      :datetime,
      name: :index_for_intensity_entries,
      message: "Datetime is already present."
    )
  end
end
