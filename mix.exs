defmodule MazeGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :maze_generator,
      version: "0.1.0",
      description: "Library to generate mazes",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/kbsymanz/maze_generator",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/kbsymanz/maze_generator"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:struct_access, "~> 1.1.2"},
      {:benchee, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
