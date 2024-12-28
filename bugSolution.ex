```elixir
list = [1, 2, 3, 4, 5]

# Safer approach using Enum.map and ignoring the exit
Enum.map(list, fn x ->
  if x == 3 do
    # Ignore the exit; instead of terminating the process, we just return a value
    :skipped
  else
    IO.puts(x)
    x
  end
end)

#Alternative approach: handle exit in a separate process
#Spawn a process to handle the list processing
pid = spawn_link(fn ->
  Enum.each(list, fn x ->
    if x == 3 do
      Process.exit(self(), :normal)
    else
      IO.puts(x)
    end
  end)
end)

#Wait for the spawned process to finish or receive a message
receive do
  {:DOWN, ^pid, :process, _, _} -> IO.puts("Process exited")
end
```