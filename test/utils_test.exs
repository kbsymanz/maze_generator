defmodule MazeGeneratorTest.Utils do
  use ExUnit.Case
  alias MazeGenerator.{Grid, Utils}

  describe "Test horizontal_or_vertical_border" do
    test "adjacent coordinates horizontally have a vertical border" do
      assert Utils.horizontal_or_vertical_border({1, 1}, {2, 1}) === :v
    end

    test "adjacent coordinates vertically have a horizontal border" do
      assert Utils.horizontal_or_vertical_border({1, 1}, {1, 2}) === :h
    end

    test "adjacent diagonally do not share a border" do
      assert Utils.horizontal_or_vertical_border({1, 1}, {2, 2}) === nil
    end

    test "separate do not share a border" do
      assert Utils.horizontal_or_vertical_border({1, 1}, {5, 5}) === nil
    end
  end

  describe "Test open_neighbors" do
    setup do
      {:ok, grid: Grid.new(10, 10)}
    end

    test "uncarved grid has no open neighbors", %{grid: grid} do
      open = Utils.open_neighbors(grid, {5, 5})

      assert open == []
    end

    test "horizontal border is a passage", %{grid: grid} do
      open =
        grid
        |> put_in([:borders, :h, {1, 1}], :passage)
        |> Utils.open_neighbors({1, 0})

      assert ^open = [{1, 1}]
    end

    test "vertical border is a passage", %{grid: grid} do
      open =
        grid
        |> put_in([:borders, :v, {1, 1}], :passage)
        |> Utils.open_neighbors({1, 1})

      assert ^open = [{0, 1}]
    end

    test "open above and below", %{grid: grid} do
      open =
        grid
        |> put_in([:borders, :h, {1, 1}], :passage)
        |> put_in([:borders, :h, {1, 2}], :passage)
        |> Utils.open_neighbors({1, 1})

      assert {1, 0} in open
      assert {1, 2} in open
      assert length(open) === 2
    end

    test "open each side", %{grid: grid} do
      open =
        grid
        |> put_in([:borders, :v, {1, 1}], :passage)
        |> put_in([:borders, :v, {2, 1}], :passage)
        |> Utils.open_neighbors({1, 1})

      assert {0, 1} in open
      assert {2, 1} in open
      assert length(open) === 2
    end

    test "open all around", %{grid: grid} do
      open =
        grid
        |> put_in([:borders, :h, {5, 5}], :passage)
        |> put_in([:borders, :h, {5, 6}], :passage)
        |> put_in([:borders, :v, {5, 5}], :passage)
        |> put_in([:borders, :v, {6, 5}], :passage)
        |> Utils.open_neighbors({5, 5})

      assert {4, 5} in open
      assert {6, 5} in open
      assert {5, 4} in open
      assert {5, 6} in open
      assert length(open) === 4
    end
  end

  describe "Test neighbors" do
    setup do
      {:ok, grid: Grid.new(10, 10)}
    end

    test "Verify that expected cell coordinates are returned", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {5, 5})
      set = MapSet.new(neighbors)

      assert MapSet.member?(set, {5, 4})
      assert MapSet.member?(set, {5, 6})
      assert MapSet.member?(set, {4, 5})
      assert MapSet.member?(set, {6, 5})
    end

    test "Verify that coordinates that are returned are coordinates of cells", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {5, 5})

      Enum.each(neighbors, fn coordinate ->
        assert Map.get(grid.cells, coordinate, false)
      end)
    end

    test "Find neighbors of a cell not against the border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {5, 5})

      assert length(neighbors) == 4
    end

    test "Find neighbors of a cell against the north border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {3, 0})

      assert length(neighbors) == 3
    end

    test "Find neighbors of a cell against the east border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {9, 2})

      assert length(neighbors) == 3
    end

    test "Find neighbors of a cell against the south border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {3, 9})

      assert length(neighbors) == 3
    end

    test "Find neighbors of a cell against the west border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {0, 4})

      assert length(neighbors) == 3
    end

    test "Find neighbors of a cell in the northwest corner", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {0, 0})

      assert length(neighbors) == 2
    end

    test "Find neighbors of a cell in the northeast corner", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {9, 0})

      assert length(neighbors) == 2
    end

    test "Find neighbors of a cell in the southeast corner", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {9, 9})

      assert length(neighbors) == 2
    end

    test "Find neighbors of a cell in the southwest corner", %{grid: grid} do
      neighbors = Utils.neighbors(grid, {0, 9})

      assert length(neighbors) == 2
    end
  end
end
