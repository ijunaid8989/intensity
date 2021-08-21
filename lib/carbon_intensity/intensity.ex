defmodule CarbonIntensity.Intensity do
  use Ecto.Schema


  alias CarbonIntensity.{Intensity, Repo}

  import Ecto.Changeset

  @required [:datetime, :intensity]

  schema "intensity" do
    field(:datetime, :string)
    field(:intensity, :integer)
  end

  def add(params) do
    %Intensity{}
    |> changeset(params)
    |> Repo.insert(on_conflict: :nothing)
  end

  def changeset(%Intensity{} = struct, params \\ %{}) do
    struct
    |> cast(params, @required)
    |> validate_required(@required)
    |> unique_constraint(
      :title,
      name: :index_for_intensity_entries,
      message: "Datetime is already present."
    )
  end
end
