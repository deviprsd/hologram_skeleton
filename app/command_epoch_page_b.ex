defmodule HologramSkeleton.CommandEpochPageB do
  use Hologram.Page

  route "/command-epoch/b"

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <h1>Page B</h1>
    <p id="b_marker">This page has no component with cid "slow".</p>
    """
  end
end
