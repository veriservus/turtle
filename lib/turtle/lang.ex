defmodule Turtle.Lang do

  # expand("B", [{"B", "F[-B]+B"}, {"F", "FF"}], 2)
  # => "F[-B]+B+]F[-B]+B-[FF"

  def expand(axiom, rules, level) when is_list(rules) do
    expand(axiom, Map.new(rules), level)
  end

  def expand(axiom, _rules, 0) do
    axiom
  end

  def expand(axiom, rules, level) do
    expand(expand_once(String.graphemes(axiom), rules, []), rules, level-1)
  end

  defp expand_once([], _rules, acc) do
    acc
    |> Enum.reverse()
    |> Enum.join()
  end

  defp expand_once([term|terms], rules, acc) do
    expansion = Map.get(rules, term, term)
    expand_once(terms, rules, [expansion|acc])
  end
end
