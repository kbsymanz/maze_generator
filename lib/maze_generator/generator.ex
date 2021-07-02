defmodule MazeGenerator.Generator do
  @moduledoc """
  Defines the functions required to implement the Generator behavior.
  """

  @doc """
  Generate a maze.
  """
  @callback carve(Grid.t()) :: Grid.t()
end
