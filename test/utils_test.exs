defmodule MazeGeneratorTest.Utils do
  use ExUnit.Case
  alias MazeGenerator.{Cell, Grid, Utils}

  describe "Test neighbors" do
    setup do
      {:ok, grid: Grid.new(10, 10)}
    end

    test "Verify that expected cell coordinates are returned", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(5, 5))

      assert Map.has_key?(neighbors, {5, 4})
      assert Map.has_key?(neighbors, {5, 6})
      assert Map.has_key?(neighbors, {4, 5})
      assert Map.has_key?(neighbors, {6, 5})
    end

    test "Verify that cells are returned in a map with coordinates as key", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(5, 5))

      for {key, value} <- neighbors do
        assert {_x, _y} = key
        assert %Cell{} = value
      end
    end

    test "Find neighbors of a cell not against the border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(5, 5))

      assert map_size(neighbors) == 4
    end

    test "Find neighbors of a cell against the north border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(3, 0))

      assert map_size(neighbors) == 3
    end

    test "Find neighbors of a cell against the east border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(9, 2))

      assert map_size(neighbors) == 3
    end

    test "Find neighbors of a cell against the south border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(3, 9))

      assert map_size(neighbors) == 3
    end

    test "Find neighbors of a cell against the west border", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(0, 4))

      assert map_size(neighbors) == 3
    end

    test "Find neighbors of a cell in the northwest corner", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(0, 0))

      assert map_size(neighbors) == 2
    end

    test "Find neighbors of a cell in the northeast corner", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(9, 0))

      assert map_size(neighbors) == 2
    end

    test "Find neighbors of a cell in the southeast corner", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(9, 9))

      assert map_size(neighbors) == 2
    end

    test "Find neighbors of a cell in the southwest corner", %{grid: grid} do
      neighbors = Utils.neighbors(grid, Cell.new(0, 9))

      assert map_size(neighbors) == 2
    end

  end

end
