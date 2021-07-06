defmodule MazeGenerator.VisitTracker do
  @moduledoc """
  Tracks whether a given coordinate has been visited or not.
  """
  use Agent

  @doc """
  Starts an agent to track visited cells.
  """
  def start_link(),
    do: Agent.start_link(fn -> %{} end)

  @doc """
  Sets a given coordinate as visited. Default value is true but
  can be alternative value depending upon the algorithm needs.
  """
  def set_visited(agent, {_x, _y} = coordinates, value \\ true),
    do: Agent.cast(agent, fn set -> Map.put(set, coordinates, value) end)

  @doc """
  Gets the value of a given coordinate.
  """
  def get_visited(agent, {_x, _y} = coordinates),
    do: Agent.get(agent, fn set -> Map.get(set, coordinates) end)

  @doc """
  Stops the agent.
  """
  def stop_link(agent), do: Agent.stop(agent, :normal)
end
