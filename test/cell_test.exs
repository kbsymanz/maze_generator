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

  test "Detects when cells are equal" do
    cell1 = Cell.new(1, 2)
    cell2 = Cell.new(1, 2)

    assert Cell.equal(cell1, cell2)
  end

  test "Detects when cells are not equal" do
    cell1 = Cell.new(1, 2)
    cell2 = Cell.new(1, 3)
    cell3 = Cell.new(2, 2)

    refute Cell.equal(cell1, cell2)
    refute Cell.equal(cell1, cell3)
  end
end
