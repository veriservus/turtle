defmodule Turtle.Draw do
  require Logger
  alias Turtle.Lang, as: L
  alias Turtle.Fractal, as: F
  alias Scenic.Math.Line
  import Scenic.Primitives

  def draw(graph, %F{axiom: axiom, rules: rules, level: level, step_len: step_len, rot: rot, starting_pos: {x, y}}) do
    program = L.expand(axiom, rules, level)
    Logger.info("Drawing #{program}")

    do_draw(graph, step_len, rot, String.graphemes(program), {x, y, 0}, [])
  end

  def do_draw(graph, step_len, rot, steps, pos, mem) do

    {graph, _pos, _mem} =
    steps
    |> Enum.with_index(1)
    |> Enum.reduce({graph, pos, mem}, fn {step, idx}, {graph, pos, mem} ->
      {graph, pos, mem} = case step do
        "F" -> draw_forward(graph, pos, mem, step_len)
        "|" -> draw_forward_custom(graph, pos, mem, step_len, idx)
        "G" -> go_forward(graph, pos, mem, step_len)
        "+" -> turn_right(graph, pos, mem, rot)
        "-" -> turn_left(graph, pos, mem, rot)
        "[" -> save_pos(graph, pos, mem)
        "]" -> restore_pos(graph, pos, mem)
      end
      Logger.info("Step: Turtle: #{inspect(pos)}, #{inspect(mem)}")

      {graph, pos, mem}
    end)

    graph
  end

  def draw_forward(graph, {x, y, r}, mem, step) do
    x1 = x + step * :math.cos(r)
    y1 = y + step * :math.sin(r)
    Logger.info("Drawing a line from #{inspect({x, y})} to ##{inspect({x1, y1})}")

    graph =
      graph
      |> line(Line.round({{x, y}, {x1, y1}}), stroke: {1, :white})

    {graph, {x1, y1, r}, mem}
  end

  def draw_forward_custom(graph, pos, mem, step, idx) do
    step = step + step * (1 - 1/idx)

    draw_forward(graph, pos, mem, step)
  end

  def go_forward(graph, {x, y, r}, mem, step) do
    x1 = x + step * :math.cos(r)
    y1 = y + step * :math.sin(r)
    Logger.info("Moving turtle from #{inspect({x, y})} to ##{inspect({x1, y1})}")

    {graph, {x1, y1, r}, mem}
  end

  def turn_right(graph, {x, y, r}, mem, rot) do
    new_r = r + rot
    Logger.info("Rotating right from #{r} to #{new_r}")
    {graph, {x, y, new_r}, mem}
  end

  def turn_left(graph, {x, y, r}, mem, rot) do
    new_r = r - rot
    Logger.info("Rotating left from #{r} to #{new_r}")
    {graph, {x, y, new_r}, mem}
  end

  def save_pos(graph, pos, mem) do
    Logger.info("Pushing pos #{inspect(pos)} to memory")
    {graph, pos, [pos | mem]}
  end

  def restore_pos(graph, pos, []) do
    Logger.warning("An attempt at restoring empty pos")
    {graph, pos, []}
  end

  def restore_pos(graph, _pos, [old_pos|mem]) do
    Logger.info("Popping pos #{inspect(old_pos)} from memory")
    {graph, old_pos, mem}
  end
end
