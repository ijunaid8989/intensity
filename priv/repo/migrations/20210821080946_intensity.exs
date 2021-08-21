defmodule CarbonIntensity.Repo.Migrations.Intensity do
  use Ecto.Migration

  def change do
    create table(:intensity) do
      add :datetime, :string
      add :intensity, :integer
    end

    create(
      unique_index(
       :intensity,
        ~w(datetime intensity)a,
        name: :index_for_intensity_entries
      )
    )
  end
end
