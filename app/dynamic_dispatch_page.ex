defmodule HologramSkeleton.DynamicDispatchPage do
  use Hologram.Page

  route "/dynamic-dispatch"

  layout HologramSkeleton.DefaultLayout

  # The module only ever reaches client code as a value in state, the way a plug-in handed to a
  # library component does. The library cannot name it in a literal remote call.
  def init(_params, component, _server) do
    source = HologramSkeleton.PluginSource

    component
    |> put_state(:source, source)
    |> put_state(:server_says, {:validate, 2} in source.module_info(:exports))
    |> put_state(:client_says, "(click the button)")
  end

  def template do
    ~HOLO"""
    <h1>function_exported?/3 on a module held in state</h1>
    <p>Server, at render: <strong id="server">{inspect(@server_says)}</strong></p>
    <button id="check" $click="check">Check on the client</button>
    <p>Client, after click: <strong id="client">{@client_says}</strong></p>
    """
  end

  def action(:check, _params, component) do
    exported? = function_exported?(component.state.source, :validate, 2)
    IO.inspect(exported?, label: "client function_exported?(PluginSource, :validate, 2)")

    put_state(component, :client_says, inspect(exported?))
  end
end
