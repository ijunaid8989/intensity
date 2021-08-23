defmodule CI.Maintainer do
  use GenServer, restart: :transient

  alias CarbonIntensity.Intensity

  require Logger

  def start_link(_name \\ nil) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.debug("Starting Intensity Maintainer.")
    send(self(), :fetch_and_process)
    {:ok, state}
  end

  def handle_info(:fetch_and_process, state) do
    last_record_added =
      Intensity.get_last_record()
      |> last_added_records_date()
      |> IO.inspect()

    current_time = DateTime.utc_now() |> IO.inspect()
    diff = DateTime.diff(current_time, last_record_added) |> IO.inspect()

    datetimes =
      case diff > 1800 do
        true -> create_datetimes(last_record_added, diff) |> Enum.sort()
        _ -> []
      end

    case Enum.count(datetimes) > 0 do
      true ->
        Enum.each(datetimes, fn datetime ->
          CI.get("/intensity/" <> datetime)
          |> Intensity.add(on_conflict: :nothing)
        end)

        {:stop, :normal, state}

      _ ->
        {:stop, :shutdown, state}
    end
  end

  def terminate(_process, _state) do
    Logger.debug("Terminate Maintainer after work.")
  end

  defp create_datetimes(last_record_added, diff) do
    number_of_pairs = (diff / 1800) |> Float.round() |> trunc()

    {datetimes, _last_datetime} =
      Enum.reduce(1..number_of_pairs, {[], last_record_added}, fn _x, {dates, datetime} ->
        next_datetime = datetime |> DateTime.add(1800, :second)
        {[next_datetime |> DateTime.to_iso8601() | dates], next_datetime}
      end)

    datetimes
  end

  defp last_added_records_date(nil) do
    DateTime.utc_now()
  end

  defp last_added_records_date(%Intensity{datetime: datetime}) do
    {:ok, last_record_added, _offset} =
      datetime
      |> String.replace_suffix("Z", ":00Z")
      |> DateTime.from_iso8601()

    last_record_added
  end
end
