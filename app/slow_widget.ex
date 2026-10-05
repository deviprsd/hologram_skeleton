defmodule HologramSkeleton.SlowWidget do
  use Hologram.Component

  def init(_props, component, _server) do
    put_state(component, :status, "idle")
  end

  def template do
    ~HOLO"""
    <p>
      <button id="start" $click={command: :slow, target: "slow"}>Start the slow command</button>
      Widget status: <strong id="status">{@status}</strong>
    </p>
    """
  end

  def action(:slow_done, _params, component) do
    put_state(component, :status, "reply received")
  end

  # Stands in for a slow fetch: the reply is still in flight after the user has navigated away.
  def command(:slow, _params, server) do
    Process.sleep(2_000)
    put_action(server, :slow_done)
  end
end
