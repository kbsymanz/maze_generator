defmodule MazeGenerator.Grid do
  alias __MODULE__
  alias MazeGenerator.{Cell, Utils}
  use StructAccess

  @moduledoc """
  Represents a grid of cells. The width and height represent the size of the grid.
  The cells are a map of cells with an {x, y} tuple key representing the cell location.

  The borders are horizontal and vertical borders that represent the borders between
  cells, which are shared by cells, which employs an {:h | :v, x, y} tuple key.
  Horizontal borders (:h) are those whose bars lie horizontal and are the separators
  between vertically aligned cells. Vertical borders (:v) are those whose bars lie
  vertical and are the separators between horizontally aligned cells.
  """

  @type state :: :valid | :uninitialized | :invalid_width_height | :no_paths

  @type t :: %__MODULE__{
          width: pos_integer,
          height: pos_integer,
          cells: map(),
          borders: map,
          paths: map(),
          state: state
        }

  @enforce_keys [:width, :height, :cells, :borders, :paths, :state]

  defstruct [:width, :height, :cells, :borders, :paths, :state]

  @doc """
  Creates a new Grid of the specified dimensions. Initializes the borders as walls
  and sets the state to invalid since the path has not been carved.
  """
  def new(width, height)
      when is_integer(width) and width > 1 and is_integer(height) and height > 1 do
    generate_grid(width, height, :uninitialized)
  end

  def new(width, height) do
    generate_grid(width, height, :invalid_width_height)
  end

  @doc """
  Opens a passage in the border between two adjacent cells. If the
  cells are not adjacent or is the same cell, it does nothing.
  """
  @spec open_passage(Grid.t(), Cell.t(), Cell.t()) :: Grid.t()
  def open_passage(grid, %Cell{} = one, %Cell{x: x2, y: y2} = two) do
    neighbors_of_one = Utils.neighbors(grid, one)

    new_grid =
      case Map.has_key?(neighbors_of_one, {x2, y2}) do
        true ->
          case horizontal_or_vertical(one, two) do
            :h ->
              put_in(grid, [:borders, :h, {x2, y2}], :passage)

            :v ->
              put_in(grid, [:borders, :v, {x2, y2}], :passage)

            nil ->
              # is it better to throw here since we know we should never get here?
              grid
          end

        false ->
          # The cells are not neighbors, so they have no border wall between them.
          grid
      end

    new_grid
  end

  @doc """
  Sets a cell in the grid to visited, defaulting to true.
  """
  @spec set_visited(Grid.t(), Cell.t(), value :: boolean | atom) :: Grid.t()
  def set_visited(grid, cell, value \\ true)

  def set_visited(%Grid{} = grid, %Cell{x: x, y: y} = _cell, value) do
    visited_cell =
      grid
      |> get_in([:cells, {x, y}])
      |> Cell.set_visited(value)

    put_in(grid, [:cells, {x, y}], visited_cell)
  end

  defp horizontal_or_vertical(%Cell{x: x1, y: y1}, %Cell{x: x2, y: y2}) do
    cond do
      x1 == x2 ->
        :h

      y1 == y2 ->
        :v

      true ->
        nil
    end
  end

  defp generate_grid(width, height, state) do
    %Grid{
      width: width,
      height: height,
      cells: generate_initial_cells(width, height),
      borders: generate_initial_borders(width, height),
      paths: %{},
      state: state
    }
  end

  defp generate_initial_cells(width, height) do
    for x <- 0..(width - 1), y <- 0..(height - 1), into: %{}, do: {{x, y}, Cell.new(x, y)}
  end

  defp generate_initial_borders(width, height) do
    %{}
    |> put_in([:h], generate_initial_h_borders(width, height))
    |> put_in([:v], generate_initial_v_borders(width, height))
  end

  defp generate_initial_h_borders(width, height) do
    for x <- 0..(width - 1), y <- 0..height, into: %{}, do: {{x, y}, :wall}
  end

  defp generate_initial_v_borders(width, height) do
    for x <- 0..width, y <- 0..(height - 1), into: %{}, do: {{x, y}, :wall}
  end
end
