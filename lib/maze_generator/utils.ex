defmodule MazeGenerator.Utils do
  @moduledoc """
  Provides some utility functions for mazes and grids.
  """

  alias MazeGenerator.{Cell, Grid}

  @doc """
  Returns a map of neighboring cells of the cell and grid passed with the coordinates
  as the key and the cell as the value.
  """
  @spec neighbors(Grid.t(), Cell.t() | {pos_integer, pos_integer}) :: map
  def neighbors(%Grid{} = grid, %Cell{} = cell) do
    unverified_neighbors = [
      {cell.x, cell.y - 1},
      {cell.x + 1, cell.y},
      {cell.x, cell.y + 1},
      {cell.x - 1, cell.y}
    ]

    Enum.filter(unverified_neighbors, fn coordinates -> Map.has_key?(grid.cells, coordinates) end)
    |> Enum.map(fn coordinate -> {coordinate, Map.get(grid.cells, coordinate)} end)
    |> Enum.into(%{})
  end

  def neighbors(%Grid{} = grid, {x, y}), do: neighbors(grid, Cell.new(x, y))

end
