defmodule CITest do
  use ExUnit.Case
  doctest CI

  test "greets the world" do
    assert CI.hello() == :world
  end
end
