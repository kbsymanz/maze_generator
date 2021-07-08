# MazeGenerator

A maze generation library in Elixir.

![Example 50 x 30 maze](maze_example.png)
*An example 50 x 30 maze.*

## Features

- Generates a maze of specified width and height (in cells) using the
  Recursive Backtracker algorithm.
- See [Maze View](https://github.com/kbsymanz/maze_view) for an example
  application that uses the library and outputs SVG.

## Upcoming Features

- Solver that creates an ingress and egress in the maze between various
priorities such as longest path, shortest path between specified sides, etc.
- Different algorithms such as Wilson's, Hunt and Kill, etc.

## Credits

- Thank you to Jamis Buck and his book, "Mazes for Programmers: Code Your Own
  Twisty Little Passages", for the recursive backtracker algorithm.
