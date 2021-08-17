defmodule MazeGenerator.Utils do
  @moduledoc """
  Provides some utility functions for mazes and grids.
  """

  alias MazeGenerator.Grid

  @doc """
  Returns a list of neighboring coordinates for the coordinate in the grid.
  """
  @spec neighbors(Grid.t(), {pos_integer, pos_integer}) :: list({pos_integer, pos_integer})
  def neighbors(%Grid{} = grid, {x, y} = _coordinate) when is_number(x) and is_number(y) do
    unverified_neighbors = [
      {x, y - 1},
      {x + 1, y},
      {x, y + 1},
      {x - 1, y}
    ]

    Enum.filter(unverified_neighbors, fn coordinates -> Map.has_key?(grid.cells, coordinates) end)
  end

  @doc """
  Returns a list of neighboring coordinates for the coordinate in the grid that 
  have a border set to :passage between themselves and the coordinate passed.
  """
  def open_neighbors(%Grid{} = grid, {coordinate_x, coordinate_y} = coordinate) do
    neighbors(grid, coordinate)
    |> Enum.filter(fn {neighbor_x, neighbor_y} = neighbor ->
      case horizontal_or_vertical_border(coordinate, neighbor) do
        :h ->
          grid.borders.h[{neighbor_x, max(coordinate_y, neighbor_y)}] === :passage

        :v ->
          grid.borders.v[{max(coordinate_x, neighbor_x), neighbor_y}] === :passage

        nil ->
          false
      end
    end)
  end

  @doc """
  Returns whether the border wall between two coordinates is a vertical border or a
  horizontal border, i.e., whether the border line is vertical or horizontal.
  """
  @spec horizontal_or_vertical_border({pos_integer, pos_integer}, {pos_integer, pos_integer}) ::
          :h | :v | nil
  def horizontal_or_vertical_border({x1, y1}, {x2, y2}) do
    cond do
      x1 == x2 && abs(y1 - y2) == 1 ->
        :h

      y1 == y2 && abs(x1 - x2) == 1 ->
        :v

      true ->
        nil
    end
  end
end
