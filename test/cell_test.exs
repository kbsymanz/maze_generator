defmodule MazeGeneratorTest.Cell do
  use ExUnit.Case
  alias MazeGenerator.Cell

  test "Creates a new cell at specified position with all walls" do
    cell = Cell.new(1, 2)

    assert cell.x === 1
    assert cell.y === 2
    assert cell.n === {1, 2}
    assert cell.e === {2, 2}
    assert cell.s === {1, 3}
    assert cell.w === {1, 2}
  end
end
