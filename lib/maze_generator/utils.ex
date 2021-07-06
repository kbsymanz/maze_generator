defmodule MazeGenerator.Utils do
  @moduledoc """
  Provides some utility functions for mazes and grids.
  """

  alias MazeGenerator.Grid

  @doc """
  Returns a map of neighboring cells of the cell and grid passed with the coordinates
  as the key and the cell as the value.
  """
  @spec neighbors(Grid.t(), {pos_integer, pos_integer}) :: list({pos_integer, pos_integer})
  def neighbors(%Grid{} = grid, {x, y} = _coordinate) do
    unverified_neighbors = [
      {x, y - 1},
      {x + 1, y},
      {x, y + 1},
      {x - 1, y}
    ]

    Enum.filter(unverified_neighbors, fn coordinates -> Map.has_key?(grid.cells, coordinates) end)
  end
end
