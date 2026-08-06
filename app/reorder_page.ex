defmodule HologramSkeleton.ReorderPage do
  use Hologram.Page

  route "/reorder"

  layout HologramSkeleton.DefaultLayout

  def init(_params, component, _server) do
    items = for i <- 1..5, do: %{id: i, label: "Row #{i}"}
    put_state(component, :items, items)
  end

  def template do
    ~HOLO"""
    <div>
      <h1>Fragment reorder probe (v0.11.0, no keyed lists)</h1>
      <ul>
        {%for item <- @items}
          <li data-row-id={item.id}>
            {%if item.id > 0}
              <span>{item.label}</span>
            {/if}
          </li>
        {/for}
      </ul>
      <button $click={action: :swap}>Swap rows 2 and 3</button>
    </div>
    """
  end

  def action(:swap, _params, component) do
    [a, b, c, d, e] = component.state.items
    put_state(component, :items, [a, c, b, d, e])
  end
end
