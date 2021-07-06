defmodule MazeGenerator.Cell do
  alias __MODULE__

  @moduledoc """
  Represents a cell.

  x: zero based horizontal position starting from the left.
  y: zero based vertical position starting from the top.
  n: north wall, x/y coordinates
  e: east wall, x/y coordinates
  s: south wall, x/y coordinates
  w: west wall, x/y coordinates
  """

  @enforce_keys [:x, :y, :n, :e, :s, :w]

  @type t :: %__MODULE__{
          x: pos_integer,
          y: pos_integer,
          n: {pos_integer, pos_integer},
          e: {pos_integer, pos_integer},
          s: {pos_integer, pos_integer},
          w: {pos_integer, pos_integer}
        }

  defstruct ~w( x y n e s w )a

  @doc """
  Creates a new Cell at the specified position with borders references set.
  """
  def new(x, y) do
    %Cell{
      x: x,
      y: y,
      n: {x, y},
      e: {x + 1, y},
      s: {x, y + 1},
      w: {x, y}
    }
  end

  @doc """
  Returns whether the two cells passed are the same cell.
  """
  def equal(%Cell{x: x1, y: y1}, %Cell{x: x2, y: y2}) do
    x1 == x2 && y1 == y2
  end
end
