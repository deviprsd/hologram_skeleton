defmodule HologramSkeleton.MatchPerfPage do
  use Hologram.Page

  route "/match-perf"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    big_map = Map.new(1..500, fn i -> {i, i} end)
    component
    |> put_state(:big_map, big_map)
    |> put_state(:elapsed_ms, nil)
  end

  def template do
    ~HOLO"""
    <div>
      <h1>matchOperator re-walk probe (500-entry map, 28 dispatches)</h1>
      <button $click={action: :run}>Run</button>
      {%if @elapsed_ms}
        <p>elapsed: {@elapsed_ms} ms</p>
      {/if}
    </div>
    """
  end

  def action(:run, _params, component) do
    big_map = component.state.big_map
    start = :erlang.monotonic_time(:millisecond)

    # Map.get/3 is itself multi-clause in the stdlib, so each call re-matches
    # the same (unchanging) big_map subject against several clause patterns -
    # the same shape as the reported bug.
    for i <- 1..28 do
      Map.get(big_map, i)
    end

    elapsed = :erlang.monotonic_time(:millisecond) - start
    put_state(component, :elapsed_ms, elapsed)
  end
end
