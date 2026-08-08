defmodule HologramSkeleton.MapsFetchPage do
  use Hologram.Page

  import Hologram.Commons.KernelUtils, only: [inspect: 1]
  import Kernel, except: [inspect: 1]

  route "/compiler-bugs/maps-fetch"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    component
    |> put_state(:map, %{a: 1, b: 2})
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
      case Map.fetch(component.state.map, :b) do
        {:ok, v} -> v
        :error -> :not_found
      end

    put_state(component, :result, result)
  end
end
