defmodule Turtle.Fractal do
  alias Turtle.Fractal, as: F

  defstruct [
    :axiom,
    :rules,
    :level,
    :step_len,
    :rot,
    :starting_pos
  ]

  @type t :: %__MODULE__{
    axiom: String.t(),
    rules: list(),
    level: integer(),
    step_len: integer(),
    rot: integer(),
    starting_pos: tuple()
  }

  def carpet() do
    %F{
      axiom: "F-F-F-F",
      rules: [{"F", "F[F]-F+F[--F]+F-F"}],
      level: 4,
      step_len: 20,
      rot: 90,
      starting_pos: {:min, :max}
    }
  end

  def tree() do
    %F{
      axiom: "G",
      rules: [
        {"G", "F+[[G]-G]-F[-FG]+G"},
        {"F", "FF"}
      ],
      level: 6,
      step_len: 20,
      rot: 25,
      starting_pos: {:min, :half}
    }
  end

  def penrose_flake() do
    %F{
      axiom: "F4-F4-F4-F4-F",
      rules: [{"F", "F4-F4-F10-F++F4-F"}],
      level: 4,
      step_len: 20,
      rot: 18,
      starting_pos: {:half, :max}
    }
  end

  # for some reason this comes out wonky
  def penrose_tile() do
    %F{
      axiom: "[X]++[X]++[X]++[X]++[X]",
      rules: [
        {"X", "+YF--ZF[3-WF--XF]+"},
        {"W", "YF++ZF4-XF[-YF4-WF]++"},
        {"Y", "-WF++XF[+++YF++ZF]-"},
        {"Z", "--YF++++WF[+ZF++++XF]--XF"}
      ],
      level: 4,
      step_len: 20,
      rot: 36,
      starting_pos: {:half, :half}
    }
  end


  def sierpinski() do
    %F{
      axiom: "F--F--F",
      rules: [
        {"F", "F--F--F--GG"},
        {"G", "GG"}
      ],
      level: 6,
      step_len: 20,
      rot: 60,
      starting_pos: {:min, :max}
    }
  end

  def dragon_curve() do
    %F{
      axiom: "F",
      rules: [
        {"F", "[+F][+G--G4-F]"},
        {"G", "-G++G-"}
      ],
      level: 12,
      step_len: 10,
      rot: 45,
      starting_pos: {:half, :half}
    }
  end
end
