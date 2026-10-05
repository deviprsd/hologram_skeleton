defmodule HologramSkeleton.InCheckAsyncPage do
  use Hologram.Page
  use Hologram.JS

  route "/in-check-async"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    put_state(component, :result, "(click the button)")
  end

  def template do
    ~HOLO"""
    <h1>Bug: the same check, but a sibling clause awaits</h1>
    <button id="check" $click="check">reason in [nil, ""]</button>
    <p>Result: <strong id="result">{@result}</strong></p>
    """
  end

  # Identical to the control page's clause. It never awaits anything.
  def action(:check, _params, component) do
    reason = nil
    blank? = reason in [nil, ""]

    put_state(component, :result, "ok: #{inspect(blank?)}")
  end

  # Never invoked here. Its Task.await/1 marks the whole action/3 MFA async at the call-graph
  # level, so every clause above is compiled as async.
  def action(:wait, _params, component) do
    value =
      "new Promise(resolve => setTimeout(() => resolve(2), 10))"
      |> JS.eval()
      |> Task.await()

    put_state(component, :result, inspect(value))
  end
end
