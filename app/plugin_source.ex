defmodule HologramSkeleton.PluginSource do
  @moduledoc "A plug-in implementing an optional callback of a behaviour."

  def validate(value, _row), do: if(value == "", do: {:error, "blank"}, else: :ok)
end
