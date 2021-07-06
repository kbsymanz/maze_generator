alias MazeGenerator, as: Mg

Benchee.run(%{
  grid_recursive_10_10: fn -> Mg.new(10, 10, :recursive_backtracker) end,
  grid_recursive_20_20: fn -> Mg.new(20, 20, :recursive_backtracker) end,
  grid_recursive_40_40: fn -> Mg.new(40, 40, :recursive_backtracker) end
})
