defmodule HologramSkeleton.ActionRacePage do
  use Hologram.Page
  use Hologram.JS

  route "/action-race"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    put_state(component, :count, 0)
  end

  def template do
    ~HOLO"""
    <div>
      <h1>action/3 dispatch race probe</h1>
      <p>
        action/3 below has an unrelated sibling clause (:do_async) that
        resolves through Task.await - never invoked by this page, just
        present in the same multi-clause function.
      </p>
      <button id="bump_btn" $click={action: :bump}>Bump</button>
      <button id="fire_30_btn" $click={action: :fire_30}>
        Fire 30 real clicks in a tight sync loop
      </button>
      <p>Count: <strong id="count">{@count}</strong></p>
    </div>
    """
  end

  # Never touches Task.await/1 - a plain synchronous action.
  def action(:bump, _params, component) do
    put_state(component, :count, component.state.count + 1)
  end

  # Fires 30 real native click events on #bump_btn in a tight synchronous
  # loop - no setTimeout, no await between dispatches. This is the same DOM
  # event path (delay: 0) a fast keyboard-repeat burst goes through.
  def action(:fire_30, _params, component) do
    ~JS"""
    const btn = document.getElementById("bump_btn");
    for (let i = 0; i < 30; i++) {
      btn.dispatchEvent(new MouseEvent("click", {bubbles: true}));
    }
    """

    component
  end

  # Sibling clause - its mere presence in action/3 is what marks the whole
  # MFA async at the call-graph level (list_async_mfas is per-MFA, not
  # per-clause), which is what makes :bump above race under rapid dispatch.
  def action(:do_async, _params, component) do
    result =
      "new Promise(resolve => setTimeout(() => resolve(2), 10))"
      |> JS.eval()
      |> Task.await()

    put_state(component, :async_result, result)
  end
end
