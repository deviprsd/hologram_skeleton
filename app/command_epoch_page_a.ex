defmodule HologramSkeleton.CommandEpochPageA do
  use Hologram.Page

  route "/command-epoch/a"

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <h1>Page A</h1>
    <p>1. Start the slow command. 2. Within 2 seconds, go to page B.</p>
    <HologramSkeleton.SlowWidget cid="slow" />
    <p><Hologram.UI.Link to={HologramSkeleton.CommandEpochPageB} id="go">Go to page B</Hologram.UI.Link></p>
    """
  end
end
