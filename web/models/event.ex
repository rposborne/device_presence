defmodule DevicePresence.Event do
  use DevicePresence.Web, :model
  use Timex
  @event_epoch %DateTime{
    year: 2016,
    month: 10,
    day: 12,
    hour: 12,
    minute: 23,
    second: 15,
    microsecond: 0,
    zone_abbr: "UTC",
    utc_offset: 0,
    std_offset: 0,
    time_zone: "UTC"
  }

  schema "events" do
    field :started_at, Timex.Ecto.DateTime
    field :ended_at, Timex.Ecto.DateTime
    field :event_type, :string
    belongs_to :device, DevicePresence.Device
    belongs_to :user, DevicePresence.User
    belongs_to :collector, DevicePresence.Collector

    timestamps
  end

  @fields [:device_id, :user_id, :collector_id, :event_type, :started_at, :ended_at]
  @required_fields [:collector_id, :event_type, :started_at]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
    |> validate_required(@required_fields)
  end

  def for_device(device_id, dir \\ :desc) do
    from e in __MODULE__,
      where: e.device_id == ^device_id,
      order_by: [{^dir, e.inserted_at}]
  end

  def for_user(user_id, dir \\ :desc) do
    from e in __MODULE__,
      where: e.user_id == ^user_id,
      order_by: [{^dir, e.inserted_at}]
  end

  def for_day(query, date) do
    from e in query,
      where:
      e.started_at >= ^Timex.beginning_of_day(date) and e.started_at <= ^Timex.end_of_day(date) or e.ended_at >= ^Timex.beginning_of_day(date) and e.ended_at <= ^Timex.end_of_day(date)
  end

  def most_recent(query) do
    from o in query,
      order_by: [desc: o.inserted_at],
      limit: 1
  end

  def most_recent_for(%{user: user}) do
    from(e in __MODULE__,
      where: e.user_id == ^user.id,
      order_by: [desc: e.inserted_at],
      limit: 1)
  end

  def most_recent_for(%{device: device}) do
    from(e in __MODULE__,
      where: e.device_id == ^device.id,
      order_by: [desc: e.inserted_at],
      limit: 1)
  end

  def duration(event) do
    Timex.diff(event.ended_at || Timex.now, event.started_at, :minutes)
  end

  @doc ~S"""
  Determine the number of minutes that have passed in the current day

  ## Examples

      iex> DevicePresence.Event.duration_of_day(
      ...>  Timex.to_datetime({{2015, 4, 17}, {14, 00, 34}}, "America/Chicago"),
      ...>  %DevicePresence.Event{
      ...>    started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2015},
      ...>    ended_at: %{day: 17, hour: 14, min: 1, month: 4, sec: 0, year: 2015}
      ...>  }
      ...> )
      1

  """
  def duration_of_day(date, event) do
    timezone = Timex.Timezone.get date.time_zone
    end_at = event.ended_at |> time_in_timezone_or_now(timezone)
    start_at = event.started_at |> time_in_timezone_or_now(timezone)
    Timex.diff(
      time_or_end_of_day(date, end_at),
      time_or_beginning_of_day(date, start_at),
      :minutes
    )
  end

  def time_or_beginning_of_day(date, time) do
    beginning_of_day = Timex.Timezone.beginning_of_day(date)
    case Timex.before?(time, beginning_of_day) do
      true -> beginning_of_day
      false -> time
    end
  end

  def time_or_end_of_day(date, time) do
    end_of_day = Timex.Timezone.end_of_day(date)
    case Timex.after?(time, end_of_day) do
      true -> end_of_day
      false -> time
    end
  end

  def time_in_timezone_or_now(time, timezone ) do
    case time do
      nil -> Timex.Timezone.name_of(timezone) |> Timex.now
      time -> Timex.Timezone.convert(time, timezone)
    end
  end

end
