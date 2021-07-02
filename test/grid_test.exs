defmodule MazeGeneratorTest.Grid do
  use ExUnit.Case
  alias MazeGenerator.Grid
  import ExUnit.CaptureIO

  test "Create a grid with populated cells and borders" do
    w = 3
    h = 5
    grid = Grid.new(w, h)

    assert grid.width === w
    assert grid.height === h
    assert Map.to_list(grid.borders[:h]) |> Enum.count() == w * (h + 1)
    assert Map.to_list(grid.borders[:v]) |> Enum.count() == (w + 1) * h
    assert Map.to_list(grid.cells) |> Enum.count() === w * h
  end

  test "A new grid starts with an uninitialized state" do
    assert Grid.new(10, 10).state == :uninitialized
  end

  test "A new grid starts with an empty path map" do
    assert Grid.new(7, 3).paths |> Enum.count() == 0
  end

  test "A new grid cannot be created with a width or height of zero or less" do
    assert Grid.new(0, 0).state == :invalid_width_height
    assert Grid.new(1, 0).state == :invalid_width_height
    assert Grid.new(0, 1).state == :invalid_width_height
    assert Grid.new(-1, -1).state == :invalid_width_height
    assert Grid.new(-1, 1).state == :invalid_width_height
    assert Grid.new(1, -1).state == :invalid_width_height
  end

  describe "opening and closing passages" do
    setup do
      {:ok, grid: Grid.new(10, 10)}
    end

    test "cannot open a passage when cells are not neighbors", %{grid: grid} do
      new_grid =
        Grid.open_passage(
          grid,
          Map.get(grid.cells, {4, 4}, :one),
          Map.get(grid.cells, {7, 7}, :two)
        )

      assert Enum.all?(Map.values(new_grid.borders[:h]), fn x -> x == :wall end)
      assert Enum.all?(Map.values(new_grid.borders[:v]), fn x -> x == :wall end)
    end

    test "can open a passage when cells are horizontal neighbors", %{grid: grid} do
      new_grid =
        Grid.open_passage(
          grid,
          Map.get(grid.cells, {0, 0}, :one),
          Map.get(grid.cells, {1, 0}, :two)
        )

      assert get_in(new_grid, [:borders, :v, {1, 0}]) == :passage
    end

    test "can open a passage when cells are vertical neighbors", %{grid: grid} do
      new_grid =
        Grid.open_passage(
          grid,
          Map.get(grid.cells, {0, 0}, :one),
          Map.get(grid.cells, {0, 1}, :two)
        )

      assert get_in(new_grid, [:borders, :h, {0, 1}]) == :passage
    end
  end

  describe "Setting cells as visited" do
    setup do
      {:ok, grid: Grid.new(10, 10)}
    end

    test "a cell can be marked as visited with default value of false", %{grid: grid} do
      cell = grid.cells[{2, 2}]
      new_grid = Grid.set_visited(grid, cell)

      assert new_grid.cells[{2, 2}].visited == true
    end

    test "a cell can be marked as visited with an atom", %{grid: grid} do
      cell = grid.cells[{2, 2}]
      new_grid = Grid.set_visited(grid, cell, :any_atom)

      assert new_grid.cells[{2, 2}].visited == :any_atom
    end
  end
end
