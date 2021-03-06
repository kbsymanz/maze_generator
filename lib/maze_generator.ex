defmodule MazeGenerator do
  @moduledoc """
  Creates a maze with a guaranteed path from any specified cell to any other cell
  in the maze.
  """

  alias MazeGenerator.{Grid, RecursiveBacktracker}

  @algorithms [:recursive_backtracker]

  @doc """
  Generates a new maze of the specified width and height using the requested algorithm.
  Does not generate an ingress or egress.
  """
  @spec new(non_neg_integer, non_neg_integer, atom) ::
          {:ok, MazeGenerator.Grid.t()} | {:error, String.t()}
  def new(width, height, algorithm \\ :recursive_backtracker)

  def new(width, height, algorithm)
      when algorithm in @algorithms and is_integer(width) and width > 0 and is_integer(height) and
             height > 0 do
    grid =
      Grid.new(width, height)
      |> carve(algorithm)

    # sanity check here for validity of grid.

    {:ok, grid}
  end

  def new(_width, _height, _algorithm), do: {:error, "Invalid algorithm specified."}

  @doc """
  Populate the ingress_paths map in the grid with the longest path from the given
  ingress.
  """
  @spec populate_paths_from_ingress(Grid.t(), {pos_integer, pos_integer}) :: Grid.t()
  def populate_paths_from_ingress(%Grid{} = grid, {_x, _y} = ingress) do
    Grid.populate_paths_from_ingress(grid, ingress)
  end

  defp carve(grid, :recursive_backtracker), do: RecursiveBacktracker.carve(grid)
end
