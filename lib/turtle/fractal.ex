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
      rules: [{"G", "F+[[G]-G]-F[-FG]+G"}, {"F", "FF"}],
      level: 6,
      step_len: 20,
      rot: 25,
      starting_pos: {:min, :half}
    }
  end
end
