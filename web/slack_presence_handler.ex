defmodule DevicePresence.SlackPresenceHandler do
  alias DevicePresence.Repo

  import Ecto.Query, only: [from: 2]
  alias DevicePresence.User
  alias DevicePresence.Event

  # For a collector, go through users, see who is reporting.
  # If expect online, and in payload, do nothing.
  # If state change has occurred record an event
  def update_status(collector, params) do
    user = find(params["user"])
    store_event(collector, user, params["presence"])
  end

  def persist_user(params) do
    find_or_build(params) |> Repo.insert_or_update
  end

  def find(params) do
    query = from u in User,
            where: u.slack_user_id == (^params["id"]) or u.email == (^params["profile"]["email"])

    Repo.one(query)
  end

  # This is params not a user object(< what's the right term for this)
  defp find_or_build(params) do
    existing_user = find(params)

    scrubed_params = %{
      name: params["real_name"],
      email: params["profile"]["email"],
      slack_user_id: params["id"],
      slack_mention_name: params["name"]
    }

    if !existing_user  do
      User.changeset(%User{}, scrubed_params)
    else
      User.changeset(existing_user, scrubed_params )
    end
  end

  def store_event(collector, user, type) do
    event_time = DateTime.utc_now
    update_prev_event(user, event_time)

    Event.changeset(%Event{}, %{collector_id: collector.id, user_id: user.id, event_type: type, started_at: event_time}) |> Repo.insert!
  end

  # TODO track if we actually are seeing a status change.
  def update_prev_event(user, time) do
    case Event.most_recent_for(%{user: user}) |> Repo.one do
      nil -> IO.puts "No Previous Events"
      event -> Event.changeset(event, %{ended_at: time}) |> Repo.update!
    end
  end
end
