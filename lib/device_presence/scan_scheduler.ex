defmodule DevicePresence.ScanScheduler do
  use GenServer
  # alias  DevicePresence.ScanSession
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 1 * 60 * 50) # In 2 seconds
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    IO.puts "Running Scan Session worker"
    DevicePresence.ScanSession.fetch_session
    # Start the timer again
    Process.send_after(self(), :work, 1 * 60 * 50) # In 1 minute

    {:noreply, state}
  end
end