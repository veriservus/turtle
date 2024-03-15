defmodule Turtle.Draw do
  require Logger
  alias Turtle.Lang, as: L
  alias Turtle.Fractal, as: F
  alias Scenic.Math.Line
  import Scenic.Primitives

  def draw(graph, %F{axiom: axiom, rules: rules, level: level, step_len: step_len, rot: rot, starting_pos: {x, y}}) do
    program = L.expand(axiom, rules, level)

    steps = Regex.scan(~r/[A-Z\|\+\-\[\]]{1}|\d+/,program)
    |> Enum.flat_map(&(&1))

    do_draw(graph, step_len, rot, steps, {x, y, 0, 0}, [])
  end

  def do_draw(graph, step_len, rot, steps, pos, mem) do

    {graph, _pos, _mem} =
    steps
    |> Enum.with_index(1)
    |> Enum.reduce({graph, pos, mem}, fn {step, idx}, {graph, pos, mem} ->
      {graph, pos, mem} = cond do
        step == "G"                       -> go_forward(graph, pos, mem, step_len)
        String.match?(step, ~r/[A-Z]{1}/) -> draw_forward(graph, pos, mem, step_len)
        step == "|"                       -> draw_forward_custom(graph, pos, mem, step_len, idx)
        step == "+"                       -> turn_right(graph, pos, mem, rot)
        step == "-"                       -> turn_left(graph, pos, mem, rot)
        step == "["                       -> save_pos(graph, pos, mem)
        step == "]"                       -> restore_pos(graph, pos, mem)
        true                              -> handle_num(graph, pos, mem, Integer.parse(step))
      end

      {graph, pos, mem}
    end)

    graph
  end

  def draw_forward(graph, {x, y, r, n}, mem, step) do
    x1 = x + step * :math.cos(r)
    y1 = y + step * :math.sin(r)

    graph =
      graph
      |> line(Line.round({{x, y}, {x1, y1}}), stroke: {1, :white})

    {graph, {x1, y1, r, n}, mem}
  end

  def draw_forward_custom(graph, pos, mem, step, idx) do
    step = step + step * (1 - 1/idx)

    draw_forward(graph, pos, mem, step)
  end

  def go_forward(graph, {x, y, r, n}, mem, step) do
    x1 = x + step * :math.cos(r)
    y1 = y + step * :math.sin(r)

    {graph, {x1, y1, r, n}, mem}
  end

  def turn_right(graph, {x, y, r, n}, mem, rot) do
    new_r = case n do
      0 -> r + rot
      _ -> r + rot * n
    end
    {graph, {x, y, new_r, 0}, mem}
  end

  def turn_left(graph, {x, y, r, n}, mem, rot) do
    new_r = case n do
      0 -> r - rot
      _ -> r - rot * n
    end
    {graph, {x, y, new_r, 0}, mem}
  end

  def save_pos(graph, pos, mem) do
    {graph, pos, [pos | mem]}
  end

  def restore_pos(graph, pos, []) do
    Logger.warning("An attempt at restoring empty pos")
    {graph, pos, []}
  end

  def restore_pos(graph, _pos, [old_pos|mem]) do
    {graph, old_pos, mem}
  end

  def handle_num(graph, pos, mem, :error) do
    {graph, pos, mem}
  end

  def handle_num(grap, {x, y, r, _n}, mem, {n, _}) do
    {grap, {x, y, r, n}, mem}
  end
end
