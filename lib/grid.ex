defmodule MazeGenerator.Grid do
  alias __MODULE__
  alias MazeGenerator.Cell

  @moduledoc """
  Represents a grid of cells. The width and height represent the size of the grid.
  The cells are a map of cells with an {x, y} tuple representing the cell location.
  The h_borders and v_borders are horizontal and vertical borders, respectively,
  that represent the borders between cells, which are shared by cells.
  """

  @enforce_keys [:width, :height, :cells, :h_borders, :v_borders]

  @type t :: %__MODULE__{
          width: non_neg_integer,
          height: non_neg_integer,
          cells: map(),
          h_borders: map(),
          v_borders: map()
        }

  defstruct [:width, :height, :cells, :h_borders, :v_borders]

  @doc """
  Creates a new Grid of the specified dimensions. Initializes the borders as walls.
  """
  def new(width, height)
      when is_integer(width) and width > 1 and is_integer(height) and height > 1 do
    cells = for x <- 0..(width - 1), y <- 0..(height - 1), into: %{}, do: {{x, y}, Cell.new(x, y)}
    h_borders = for x <- 0..(width - 1), y <- 0..height, into: %{}, do: {{x, y}, :wall}
    v_borders = for x <- 0..width, y <- 0..(height - 1), into: %{}, do: {{x, y}, :wall}

    %Grid{width: width, height: height, cells: cells, h_borders: h_borders, v_borders: v_borders}
  end
end
