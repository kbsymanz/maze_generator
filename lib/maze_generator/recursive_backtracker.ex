defmodule MazeGenerator.RecursiveBacktracker do
  @moduledoc """
  Implements the Recursive Backtracker algorithm.
  """

  alias MazeGenerator.{Cell, Grid, Utils}
  @behaviour MazeGenerator.Generator

  @doc """
  Carves a maze in the grid passed using the Recursive Backtracker algorithm
  and stores the results in the grid's borders element in the form of passages
  and walls.
  """
  @spec carve(Grid.t()) :: Grid.t()
  def carve(
        %Grid{
          width: width,
          height: height,
          cells: _cells,
          borders: _borders,
          paths: _paths
        } = grid
      ) do
    starting_cell = get_random_cell(grid, width, height)

    carvep(grid, starting_cell, starting_cell)
  end

  defp get_random_cell(grid, width, height) do
    get_in(grid, [:cells, {Enum.random(0..(width - 1)), Enum.random(0..(height - 1))}])
  end

  defp carvep(grid, %Cell{visited: curr_cell_visited} = _curr_cell, _last_cell)
       when curr_cell_visited == true,
       do: grid

  defp carvep(grid, %Cell{} = curr_cell, %Cell{} = last_cell) do
    new_grid =
      grid
      |> Grid.open_passage(curr_cell, last_cell)
      |> Grid.set_visited(curr_cell)

    neighbors = Utils.neighbors(new_grid, curr_cell)

    Enum.reduce(Map.values(neighbors), new_grid, fn cell, the_grid ->
      carvep(the_grid, cell, curr_cell)
    end)
  end
end
