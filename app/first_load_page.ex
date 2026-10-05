defmodule HologramSkeleton.FirstLoadPage do
  use Hologram.Page

  route "/first-load"

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <h1>First-load history entry</h1>
    <p>Cold-load <code>/first-load?view=grid#row-42</code>, then inspect <code>location.href</code>.</p>
    """
  end
end
