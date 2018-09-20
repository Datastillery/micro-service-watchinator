defmodule MicroServiceWatchinatorTest do
  use ExUnit.Case
  doctest MicroServiceWatchinator

  test "greets the world" do
    assert MicroServiceWatchinator.hello() == :world
  end
end
