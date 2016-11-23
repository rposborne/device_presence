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
  @required_fields [:collector_id, :event_type, :started_at, :ended_at]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
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

  def duration_of_day(event, timezone) do
    if event.ended_at do
      end_at = Timex.Timezone.convert(event.ended_at, timezone)
    else
      end_at = Timex.Timezone.name_of(timezone) |> Timex.now
    end

    start_at = event.started_at |> Timex.Timezone.convert(timezone)

    start_at = if Timex.before?(start_at, Timex.Timezone.beginning_of_day(end_at)) do
      Timex.Timezone.beginning_of_day(end_at)
    end

    end_at = if Timex.after?(end_at, Timex.Timezone.end_of_day(start_at)) do
       Timex.Timezone.end_of_day(start_at)
    end

    Timex.diff(end_at, start_at, :minutes)
  end
end
