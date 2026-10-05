defmodule HologramSkeleton.KeydownUndefinedKeyPage do
  use Hologram.Page
  use Hologram.JS

  route "/keydown-undefined-key"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    put_state(component, :log, "(nothing yet)")
  end

  def template do
    ~HOLO"""
    <h1>keydown whose event.key is undefined</h1>
    <p>
      A keydown can reach the page with no <code>key</code>.
      The button dispatches one at each input.
    </p>
    <button id="fire" $click="fire">Fire keydown with key undefined</button>
    <input id="plain" $key_down="pressed" placeholder="$key_down">
    <input id="filtered" $key_down.escape="escaped" placeholder="$key_down.escape">
    <p>Log: <strong id="log">{@log}</strong></p>
    """
  end

  def action(:fire, _params, component) do
    ~JS"""
    for (const id of ["plain", "filtered"]) {
      const event = new KeyboardEvent("keydown", {bubbles: true});
      Object.defineProperty(event, "key", {value: undefined});
      document.getElementById(id).dispatchEvent(event);
    }
    """

    component
  end

  def action(:pressed, params, component) do
    put_state(component, :log, "pressed: #{inspect(params.event.key)}")
  end

  def action(:escaped, _params, component) do
    put_state(component, :log, "escaped")
  end
end
