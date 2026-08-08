defmodule HologramSkeleton.PartialStructPatternPage do
  use Hologram.Page

  import Hologram.Commons.KernelUtils, only: [inspect: 1]
  import Kernel, except: [inspect: 1]

  defmodule Item do
    defstruct [:kind, :value]
  end

  route "/compiler-bugs/partial-struct-pattern"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    component
    |> put_state(:item, %Item{kind: :data, value: 42})
    |> put_state(:result, nil)
  end

  def template do
    ~HOLO"""
    <button id="run_btn" $click="run"> Run </button>
    <p>Result: <strong id="result"><code>{inspect(@result)}</code></strong></p>
    """
  end

  def action(:run, _params, component) do
    result =
      case component.state.item do
        %Item{kind: :data, value: v} -> v
        _ -> :no_match
      end

    put_state(component, :result, result)
  end
end
