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

  test "Cell initial value for visited is false" do
    cell = Cell.new(3, 3)

    assert cell.visited == false
  end

  test "Cell visited can be set to true using defaults for set_visited" do
    cell = Cell.new(2, 2) |> Cell.set_visited

    assert cell.visited == true
  end

  test "Cell visited can be set to an atom" do
    cell = Cell.new(4, 5) |> Cell.set_visited(:any_atom)

    assert cell.visited == :any_atom
  end
end
