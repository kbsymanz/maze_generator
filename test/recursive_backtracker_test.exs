defmodule RecursiveBacktrackerTest do
  use ExUnit.Case
  alias MazeGenerator.Grid
  alias MazeGenerator.RecursiveBacktracker, as: RB

  describe "generating mazes" do
    setup do
      {:ok, grid: Grid.new(10, 10)}
    end

    test "verify the maze has horizontal and vertical passages", %{grid: grid} do
      new_grid = RB.carve(grid)
      cnt_v_passages = Enum.count(Map.values(new_grid.borders[:v]), fn val -> val == :passage end)
      cnt_h_passages = Enum.count(Map.values(new_grid.borders[:h]), fn val -> val == :passage end)

      assert cnt_v_passages > 0
      assert cnt_h_passages > 0
    end

    test "verify that the meta information is set", %{grid: grid} do
      new_grid = RB.carve(grid)

      assert get_in(new_grid, [:meta, :generated, :algorithm]) === :recursive_backtracker
      assert get_in(new_grid, [:meta, :generated, :timestamp]) !== nil
    end
  end
end
