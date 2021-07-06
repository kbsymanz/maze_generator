defmodule MazeGeneratorTest.Utils do
  use ExUnit.Case
  alias MazeGenerator.{Grid, Utils}

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
