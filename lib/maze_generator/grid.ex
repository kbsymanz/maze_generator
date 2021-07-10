defmodule MazeGenerator.Grid do
  alias __MODULE__
  alias MazeGenerator.Cell
  use StructAccess

  @moduledoc """
  Represents a grid of cells. The width and height represent the size of the grid.
  The cells are a map of cells with an {x, y} tuple key representing the cell location.

  The borders are horizontal and vertical borders that represent the borders between
  cells, which are shared by cells, stored as an {x, y} tuple in the :borders map under
  :h and :v keys. Horizontal borders (:h) are those whose bars lie horizontal and are 
  the separators between vertically aligned cells. Vertical borders (:v) are those 
  whose bars lie vertical and are the separators between horizontally aligned cells.
  """

  @type state :: :valid | :uninitialized | :invalid_width_height | :no_paths

  @type t :: %__MODULE__{
          width: pos_integer,
          height: pos_integer,
          cells: map(),
          borders: map,
          paths: map(),
          state: state,
          meta: map()
        }

  @enforce_keys [:width, :height, :cells, :borders, :paths, :state, :meta]

  defstruct [:width, :height, :cells, :borders, :paths, :state, :meta]

  @doc """
  Creates a new Grid of the specified dimensions. Initializes the borders as walls
  and sets the state to :uninitialized since the path has not been carved.
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
  cells are not adjacent or are the same cell, it does nothing.
  """
  @spec open_passage(Grid.t(), {pos_integer, pos_integer}, {pos_integer, pos_integer}) :: Grid.t()
  def open_passage(grid, {x1, y1} = one, {x2, y2} = two) do
    new_grid =
      case horizontal_or_vertical(one, two) do
        :h ->
          put_in(grid, [:borders, :h, {x2, max(y1, y2)}], :passage)

        :v ->
          put_in(grid, [:borders, :v, {max(x1, x2), y2}], :passage)

        nil ->
          grid
      end

    new_grid
  end

  @doc """
  Records the algorithm specified in the meta section of the grid along with
  the date and time.
  """
  @spec record_algorithm(Grid.t(), Atom.t()) :: Grid.t()
  def record_algorithm(grid, algorithm) when is_atom(algorithm) do
    grid
    |> put_in([:meta, :generated, :algorithm], algorithm)
    |> put_in([:meta, :generated, :timestamp], DateTime.utc_now())
  end

  defp horizontal_or_vertical({x1, y1}, {x2, y2}) do
    cond do
      x1 == x2 && abs(y1 - y2) == 1 ->
        :h

      y1 == y2 && abs(x1 - x2) == 1 ->
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
      state: state,
      meta: %{generated: %{algorithm: nil, timestamp: nil}}
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
