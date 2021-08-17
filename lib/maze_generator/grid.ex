defmodule MazeGenerator.Grid do
  alias __MODULE__
  alias MazeGenerator.{Cell, Path, Utils}
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
          active_path: {pos_integer, pos_integer},
          ingress_paths: map(),
          state: state,
          meta: map()
        }

  @enforce_keys [:width, :height, :cells, :borders, :active_path, :ingress_paths, :state, :meta]

  defstruct [:width, :height, :cells, :borders, :active_path, :ingress_paths, :state, :meta]

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
      case Utils.horizontal_or_vertical_border(one, two) do
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

  @doc """
  Populate the ingress_paths map in the grid with the longest path for the given
  ingress.
  """
  @spec populate_paths_from_ingress(Grid.t(), {pos_integer, pos_integer}) :: Grid.t()
  def populate_paths_from_ingress(%Grid{} = grid, {_x, _y} = ingress) do
    # Assign a value representing the number of steps from the ingress to every
    # coordinate in the grid.
    path_values = assign_path_values(grid, ingress)

    # Choose the largest value on a border as the egress, randomly selecting
    # if more than one.
    egress =
      path_values
      |> Map.to_list()
      |> filter_only_borders(grid.width, grid.height)
      |> Enum.shuffle()
      |> Enum.max_by(&elem(&1, 1))
      |> elem(0)

    # Calculate the path from the egress to the ingress to create a Path struct.
    path = %Path{
      ingress: ingress,
      egress: egress,
      path_type: :longest,
      path_between_ingress_egress: egress_to_ingress_path(grid, path_values, egress, ingress)
    }

    # Store the path and open the border walls at ingress and egress in the grid.
    new_grid =
      grid
      |> put_in([:ingress_paths, ingress], path)
      |> open_border(ingress)
      |> open_border(egress)

    new_grid
  end

  defp open_border(grid, {x, 0} = _coordinate), do: put_in(grid, [:borders, :h, {x, 0}], :passage)

  defp open_border(grid, {0, y} = _coordinate), do: put_in(grid, [:borders, :v, {0, y}], :passage)

  defp open_border(%Grid{width: _width, height: height} = grid, {x, y} = _coordinate)
       when y == height - 1,
       do: put_in(grid, [:borders, :h, {x, height}], :passage)

  defp open_border(%Grid{width: width, height: _height} = grid, {x, y} = _coordinate)
       when x == width - 1,
       do: put_in(grid, [:borders, :v, {width, y}], :passage)

  defp open_border(grid, _coordinate), do: grid

  defp egress_to_ingress_path(grid, path_values, curr_coordinate, ingress, path \\ [])

  defp egress_to_ingress_path(_grid, _path_values, ingress, ingress, path) do
    # Exclude the egress coordinate.
    path
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.reverse()
  end

  defp egress_to_ingress_path(grid, path_values, curr_coordinate, ingress, path) do
    step = path_values[curr_coordinate]

    next_coordinate =
      grid
      |> Utils.open_neighbors(curr_coordinate)
      |> Enum.find(fn coordinate ->
        path_values[coordinate] == step - 1
      end)

    egress_to_ingress_path(grid, path_values, next_coordinate, ingress, [curr_coordinate | path])
  end

  defp filter_only_borders(paths, width, height) do
    paths
    |> Enum.filter(fn {{x, y}, _step} ->
      x === 0 || x === width - 1 || y === 0 || y === height - 1
    end)
  end

  defp assign_path_values(
         grid,
         curr_coordinate,
         step \\ 0,
         coordinate_values \\ %{}
       )

  defp assign_path_values(grid, {x, y} = curr_coordinate, step, coordinate_values)
       when is_number(x) and is_number(y) do
    unvisited_open_neighbors =
      grid
      |> Utils.open_neighbors(curr_coordinate)
      |> Enum.filter(fn coordinate -> not Map.has_key?(coordinate_values, coordinate) end)

    new_coordinate_values = put_in(coordinate_values[curr_coordinate], step)

    Enum.reduce(
      unvisited_open_neighbors,
      new_coordinate_values,
      fn neighbor, acc ->
        assign_path_values(grid, neighbor, step + 1, acc)
      end
    )
  end

  defp generate_grid(width, height, state) do
    %Grid{
      width: width,
      height: height,
      cells: generate_initial_cells(width, height),
      borders: generate_initial_borders(width, height),
      active_path: nil,
      ingress_paths: %{},
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
