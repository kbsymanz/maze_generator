defmodule MazeGeneratorTest.VisitTracker do
  use ExUnit.Case
  alias MazeGenerator.VisitTracker, as: Vt

  setup do
    {:ok, pid} = Vt.start_link()
    {:ok, pid: pid}
  end

  test "can add a visit and retrieve the same", %{pid: pid} do
    coordinates = {2, 3}
    Vt.set_visited(pid, coordinates)

    assert Vt.get_visited(pid, coordinates) == true
  end

  test "can add a visit with a value", %{pid: pid} do
    coordinates = {4, 5}
    Vt.set_visited(pid, coordinates, :something)

    assert Vt.get_visited(pid, coordinates) == :something
  end

  test "a visit not added is nil", %{pid: pid} do

    assert Vt.get_visited(pid, {1, 1}) == nil
  end
end
