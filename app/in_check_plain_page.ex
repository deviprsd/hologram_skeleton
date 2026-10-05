defmodule HologramSkeleton.InCheckPlainPage do
  use Hologram.Page

  route "/in-check-plain"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    put_state(component, :result, "(click the button)")
  end

  def template do
    ~HOLO"""
    <h1>Control: action/3 with no async clause</h1>
    <button id="check" $click="check">reason in [nil, ""]</button>
    <p>Result: <strong id="result">{@result}</strong></p>
    """
  end

  def action(:check, _params, component) do
    reason = nil
    blank? = reason in [nil, ""]

    put_state(component, :result, "ok: #{inspect(blank?)}")
  end
end
