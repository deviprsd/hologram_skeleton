# Run with: mix run scripts/stale_lock_same_vm.exs
#
# A compile that is killed while it holds the compiler lock leaves the lock behind. The lock
# records this VM's OS pid, and the stale check only asks "is that OS process alive?", which is
# always true for the VM that is doing the checking. So the lock is never reclaimed.

build_dir = Path.join(Mix.Project.build_path(), "hologram")
lock_path = Path.join(build_dir, Hologram.Reflection.compiler_lock_file_name())
File.rm(lock_path)

opts = [build_dir: build_dir, force?: true]

# 1. Start a compile and kill it as soon as it holds the lock (what a supervisor brutal-kill,
#    a timeout kill or Process.exit(pid, :kill) does - none of them run `after` blocks).
victim = spawn(fn -> Mix.Tasks.Compile.Hologram.run(opts) end)

wait_for_lock = fn wait ->
  if File.exists?(lock_path), do: :ok, else: (Process.sleep(5); wait.(wait))
end

wait_for_lock.(wait_for_lock)
Process.exit(victim, :kill)
Process.sleep(200)

IO.puts("victim alive?      #{Process.alive?(victim)}")
IO.puts("lock file exists?  #{File.exists?(lock_path)}")
IO.puts("lock file content  #{inspect(File.read!(lock_path))}   (this VM's OS pid: #{System.pid()})")

# 2. Any later compile in the same VM (live reload, `recompile`) should reclaim the dead lock.
task = Task.async(fn -> Mix.Tasks.Compile.Hologram.run(opts) end)

case Task.yield(task, 15_000) do
  {:ok, _} -> IO.puts("RESULT: second compile finished - lock was reclaimed (no bug)")
  nil ->
    Task.shutdown(task, :brutal_kill)
    IO.puts("RESULT: second compile still blocked after 15s - lock never reclaimed (bug)")
end

File.rm(lock_path)
