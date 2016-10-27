defmodule Mix.Tasks.Events.CalEndAtTimes do
  use Mix.Task
  alias DevicePresence.Event
  alias DevicePresence.Device
  alias DevicePresence.Repo


  def run(_) do
    Mix.Task.run "app.start", []
    seed(Mix.env)
  end

  def seed(:dev) do
    # Any data for development goes here
    devices = Repo.all(Device)
    Enum.each devices, fn(d) -> Event.for_device(d.id, :asc) |> Repo.all |> find_missing_end_at end
  end

  def seed(:prod) do
    # Proceed with caution for production
  end

  def find_missing_end_at(events) do
    final_event = List.last(events)
    Enum.reduce events, nil, fn(e, acc) ->
      cond do
        final_event.id == e.id -> Event.changeset(e, %{ended_at: nil}) |> Repo.update
        acc -> update_event(e, acc)
        true -> ""
      end
      e
    end
  end

  def update_event(event, last_event) do
    IO.inspect "Updating record #{last_event.id}"
    Event.changeset(last_event, %{ended_at: event.started_at}) |> Repo.update
  end

end
