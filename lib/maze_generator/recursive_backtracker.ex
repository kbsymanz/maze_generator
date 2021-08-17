defmodule MazeGenerator.RecursiveBacktracker do
  @moduledoc """
  Implements the Recursive Backtracker algorithm.
  """

  alias MazeGenerator.{Grid, Utils}
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
          height: height
        } = grid
      ) do
    starting_coordinate = get_random_coordinate(width, height)

    %{grid: grid} = carve_borders(grid, %{}, starting_coordinate, starting_coordinate)

    new_grid = Grid.populate_paths_from_ingress(grid, {0, 0})

    Grid.record_algorithm(new_grid, :recursive_backtracker)
  end

  defp get_random_coordinate(width, height) do
    {Enum.random(0..(width - 1)), Enum.random(0..(height - 1))}
  end

  defp carve_borders(
         grid,
         visited,
         {_curr_x, _curr_y} = curr_coordinate,
         {_last_x, _last_y} = last_coordinate
       ) do
    case Map.has_key?(visited, curr_coordinate) do
      true ->
        %{grid: grid, visited: visited}

      _ ->
        new_visited = Map.put_new(visited, curr_coordinate, true)

        new_grid = Grid.open_passage(grid, curr_coordinate, last_coordinate)

        neighbors = Utils.neighbors(new_grid, curr_coordinate) |> Enum.shuffle()

        Enum.reduce(
          neighbors,
          %{grid: new_grid, visited: new_visited},
          fn next_coordinate,
             %{
               grid: the_grid,
               visited: the_visited
             } ->
            carve_borders(the_grid, the_visited, next_coordinate, curr_coordinate)
          end
        )
    end
  end
end
