defmodule MazeGenerator.Path do
  @moduledoc """
  Represents a path from an ingress to an egress through the maze.
  """

  @type t :: %__MODULE__{
          ingress: {non_neg_integer, non_neg_integer},
          egress: {non_neg_integer, non_neg_integer},
          path_type: atom(),
          path_between_ingress_egress: list({non_neg_integer, non_neg_integer})
        }

  @enforce_keys [:ingress, :egress, :path_type, :path_between_ingress_egress]

  defstruct [:ingress, :egress, :path_type, :path_between_ingress_egress]

  @doc """
  Creates a new path.
  """
  @spec new(
          {non_neg_integer, non_neg_integer},
          {non_neg_integer, non_neg_integer},
          atom(),
          list({non_neg_integer, non_neg_integer})
        ) :: __MODULE__.t()
  def new(ingress, egress, path_type, path_between_ingress_egress) do
    %__MODULE__{
      ingress: ingress,
      egress: egress,
      path_type: path_type,
      path_between_ingress_egress: path_between_ingress_egress
    }
  end
end
