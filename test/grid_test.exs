defmodule MazeGeneratorTest.Grid do
  use ExUnit.Case
  alias MazeGenerator.Grid

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

  describe "can record the algorithm" do
    test "a new grid has meta data structure set up" do
      grid = Grid.new(10, 10)

      assert Map.has_key?(grid, :meta)
      assert Map.has_key?(grid.meta, :generated)
      assert Map.has_key?(grid.meta.generated, :algorithm)
      assert Map.has_key?(grid.meta.generated, :timestamp)
      assert get_in(grid, [:meta, :generated, :algorithm]) === nil
      assert get_in(grid, [:meta, :generated, :timestamp]) === nil
    end

    test "can set the algorithm name and timestamp is set" do
      grid = Grid.new(10, 10)
             |> Grid.record_algorithm(:testing)

      assert grid.meta.generated.algorithm === :testing
      assert grid.meta.generated.timestamp !== nil
    end
  end

  describe "opening and closing passages" do
    setup do
      {:ok, grid: Grid.new(10, 10)}
    end

    test "cannot open a passage when cells are not neighbors", %{grid: grid} do
      new_grid = Grid.open_passage(grid, {4, 4}, {7, 7})

      assert Enum.all?(Map.values(new_grid.borders[:h]), fn x -> x == :wall end)
      assert Enum.all?(Map.values(new_grid.borders[:v]), fn x -> x == :wall end)
    end

    test "opening a passage when both cells are in the same has no effect", %{grid: grid} do
      new_grid = Grid.open_passage(grid, {2, 2}, {2, 2})

      assert Enum.all?(Map.values(new_grid.borders[:h]), fn x -> x == :wall end)
      assert Enum.all?(Map.values(new_grid.borders[:v]), fn x -> x == :wall end)
    end

    test "can open a passage when cells are horizontal neighbors", %{grid: grid} do
      new_grid = Grid.open_passage(grid, {0, 0}, {1, 0})

      assert get_in(new_grid, [:borders, :v, {1, 0}]) == :passage
    end

    test "can open a passage when cells are vertical neighbors", %{grid: grid} do
      new_grid = Grid.open_passage(grid, {0, 0}, {0, 1})

      assert get_in(new_grid, [:borders, :h, {0, 1}]) == :passage
    end

    test "opening a passage between the same cell has no effect", %{grid: grid} do
      new_grid = Grid.open_passage(grid, {1, 1}, {1, 1})

      assert grid.borders === new_grid.borders
    end
  end
end
