defmodule MazeGeneratorTest.Grid do
  use ExUnit.Case
  alias MazeGenerator.Grid

  test "Create a grid with populated cells and borders" do
    grid = Grid.new(4, 5)

    assert grid.width === 4
    assert grid.height === 5
    assert Map.to_list(grid.h_borders) |> Enum.count() === 4 * 6
    assert Map.to_list(grid.v_borders) |> Enum.count() === 5 * 5
    assert Map.to_list(grid.cells) |> Enum.count() === 4 * 5
  end
end
