defmodule HologramSkeleton.MapEqualityPage do
  use Hologram.Page

  route "/map-equality"

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <div>
      <h1>Map equality probe (isStrictlyEqual superset bug)</h1>
      <p>map1 has key a=1 only</p>
      <p>map2 has keys a=1 and b=2 (a strict superset of map1)</p>
      <p>map1 === map2: {map1_eq_map2()} (expected: false)</p>
      <p>map2 === map1: {map2_eq_map1()} (expected: false)</p>
    </div>
    """
  end

  def map1_eq_map2, do: to_string(%{a: 1} === %{a: 1, b: 2})
  def map2_eq_map1, do: to_string(%{a: 1, b: 2} === %{a: 1})
end
