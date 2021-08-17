defmodule MazeGeneratorTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  doctest MazeGenerator

  alias MazeGenerator, as: Mg

  describe "Generating a maze using algorithms" do
    test "Generate a maze using the default algorithm" do
      {:ok, grid} = Mg.new(10, 10)

      cnt_v_passages = Enum.count(Map.values(grid.borders[:v]), fn val -> val == :passage end)
      cnt_h_passages = Enum.count(Map.values(grid.borders[:h]), fn val -> val == :passage end)

      assert cnt_v_passages > 0
      assert cnt_h_passages > 0
    end

    test "Generate a maze using the recursive backtracker algorithm" do
      {:ok, grid} = Mg.new(10, 10, :recursive_backtracker)

      cnt_v_passages = Enum.count(Map.values(grid.borders[:v]), fn val -> val == :passage end)
      cnt_h_passages = Enum.count(Map.values(grid.borders[:h]), fn val -> val == :passage end)

      assert cnt_v_passages > 0
      assert cnt_h_passages > 0
    end

    test "Try to generate a maze using an unknown algorithm" do
      result = Mg.new(10, 10, :sdfjskdfjskdf)

      assert elem(result, 0) == :error
    end
  end
end
