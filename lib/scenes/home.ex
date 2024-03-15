defmodule Turtle.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Turtle.Draw
  alias Turtle.Fractal, as: F

  def init(scene, _param, _opts) do
    {w, h} = scene.viewport.size

    # f = F.carpet()
    # f = F.tree()
    # f = F.penrose_flake()
    # f = F.penrose_tile()
    # f = F.sierpinski()
    f = F.dragon_curve()

    half_w = div(w,2)
    half_h = div(h,2)

    quater_w = div(w,4)
    quater_h = div(h,4)

    x = case f.starting_pos do
      {:min, _}    -> 0
      {:max, _}    -> w
      {:half, _}   -> half_w
      {:quater, _} -> quater_w
    end

    y = case f.starting_pos do
      {_, :min}    -> 0
      {_, :max}    -> h
      {_, :half}   -> half_h
      {_, :quater} -> quater_h
    end

    f = %{f | starting_pos: {x, y}, rot: to_radians(f.rot)}

    graph = Draw.draw(Graph.build(), f)

    scene = push_graph(scene, graph)

    {:ok, scene}
  end

  def to_radians(r) do
    (r * :math.pi()) / 180
  end

  def handle_input(event, _context, scene) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, scene}
  end
end
