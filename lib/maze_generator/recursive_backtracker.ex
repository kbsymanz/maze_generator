defmodule MazeGenerator.RecursiveBacktracker do
  @moduledoc """
  Implements the Recursive Backtracker algorithm.
  """

  alias MazeGenerator.{Grid, Utils, VisitTracker}
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
    {:ok, visit_tracker} = VisitTracker.start_link()
    starting_coordinate = get_random_coordinate(width, height)

    grid = carvep(grid, visit_tracker, starting_coordinate, starting_coordinate)
    VisitTracker.stop_link(visit_tracker)

    grid
  end

  defp get_random_coordinate(width, height) do
    {Enum.random(0..(width - 1)), Enum.random(0..(height - 1))}
  end

  defp carvep(
         grid,
         visit_tracker,
         {_curr_x, _curr_y} = curr_coordinate,
         {_last_x, _last_y} = last_coordinate
       ) do
    case VisitTracker.get_visited(visit_tracker, curr_coordinate) do
      true ->
        grid

      _ ->
        VisitTracker.set_visited(visit_tracker, curr_coordinate)
        new_grid = Grid.open_passage(grid, curr_coordinate, last_coordinate)

        neighbors = Utils.neighbors(new_grid, curr_coordinate) |> Enum.shuffle()

        Enum.reduce(neighbors, new_grid, fn next_coordinate, the_grid ->
          carvep(the_grid, visit_tracker, next_coordinate, curr_coordinate)
        end)
    end
  end
end
