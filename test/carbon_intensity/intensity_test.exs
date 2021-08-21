defmodule CarbonIntensity.IntensityTest do
  use CarbonIntensity.RepoCase, async: true

  test "this will add a new intensity value correctly" do
    params = %{datetime: "2018-01-20T12:00Z", intensity: 263}

    assert {:ok, %Intensity{}} = Intensity.add(params)
  end

  test "this should return an error because of invalid params" do
    params = %{datetime: "2018-01-20T12:00Z"}

    {:error, changeset} = Intensity.add(params)
    expected_error = {"can't be blank", [validation: :required]}
    assert %Changeset{errors: [intensity: ^expected_error]} = changeset
  end

  test "this should fail to add duplicate intensity value" do
    params1 = %{datetime: "2018-01-20T12:00Z", intensity: 263}
    params2 = %{datetime: "2018-01-20T12:00Z", intensity: 263}

    Intensity.add(params1)

    {:error, changeset} = Intensity.add(params2)
    expected_error = {"Datetime is already present.", [constraint: :unique, constraint_name: "index_for_intensity_entries"]}
    assert %Changeset{errors: [datetime: ^expected_error]} = changeset
  end

  test "this should pass on duplicate intensity value with opts" do
    params1 = %{datetime: "2018-01-20T12:00Z", intensity: 263}
    params2 = %{datetime: "2018-01-20T12:00Z", intensity: 263}

    assert {:ok, %Intensity{}} = Intensity.add(params1)
    assert {:ok, %Intensity{}} = Intensity.add(params2, on_conflict: :nothing)
  end
end
