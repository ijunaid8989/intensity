defmodule CI.Intensity.Worker do
  use GenServer

  require Logger

  alias CarbonIntensity.Intensity

  def start_link(_name \\ nil) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    Logger.debug("Starting Intensity Worker.")
    duration = should_time_process?() |> timed_process()

    timer = Process.send_after(self(), :work, duration)
    {:ok, %{timer: timer}}
  end

  def handle_info(:work, %{timer: timer} = _state) do
    fetch_intensity_data()
    :timer.cancel(timer)
    duration = should_time_process?() |> timed_process()
    timer = Process.send_after(self(), :work, duration)
    {:noreply, %{timer: timer}}
  end

  @spec get_state(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def get_state(pid) do
    GenServer.call(pid, :get)
  end

  def handle_call(:get, _from, state),
    do: {:reply, state, state}

  defp fetch_intensity_data(retry \\ 4)
  defp fetch_intensity_data(0), do: Logger.debug("Just cancel the timer.")

  defp fetch_intensity_data(retry) do
    CI.get("/intensity")
    |> case do
      {:error, :nxdomain} -> Logger.debug("todo")
      {:error, _error_code, _message} -> fetch_intensity_data(retry - 1)
      data -> Intensity.add(data) |> unique_datetime()
    end
  end

  defp unique_datetime({:ok, %Intensity{}}), do: fetch_intensity_data(0)

  defp unique_datetime({:error, %Ecto.Changeset{errors: error} = _changeset}) do
    Logger.debug(error)
    fetch_intensity_data(0)
  end

  defp should_time_process?(), do: Application.get_env(:c_i, :worker)

  defp timed_process(true), do: 60000 * 20
  defp timed_process(false), do: 1000
end
