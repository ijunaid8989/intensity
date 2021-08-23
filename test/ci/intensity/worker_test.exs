defmodule CI.Intensity.WorkerTest do
  use ExUnit.Case, async: true

  alias CI.Intensity.Worker

  setup do
    {:ok, pid} = Worker.start_link()

    {:ok, pid: pid}
  end

  test "it will check the state of process and kill the timer.", %{pid: process} do
    %{timer: timer} = Worker.get_state(process)
    assert Process.cancel_timer(timer, async: true)
    assert_receive {:cancel_timer, ^timer, _miliseconds}
  end

  test "it will get the info of registered name", %{pid: process} do
    assert [registered_name: CI.Intensity.Worker] == Process.info(process, [:registered_name])
  end
end
