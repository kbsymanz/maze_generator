defmodule MazeGeneratorTest do
  use ExUnit.Case
  doctest MazeGenerator

  test "greets the world" do
    assert MazeGenerator.hello() == :world
  end
end
