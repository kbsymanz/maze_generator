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

  @directions [:n, :e, :s, :w]

  @enforce_keys [:x, :y, :n, :e, :s, :w]

  @type t :: %__MODULE__{
          x: non_neg_integer,
          y: non_neg_integer,
          n: {non_neg_integer, non_neg_integer},
          e: {non_neg_integer, non_neg_integer},
          s: {non_neg_integer, non_neg_integer},
          w: {non_neg_integer, non_neg_integer}
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
end
