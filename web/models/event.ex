defmodule DevicePresence.Event do
  use DevicePresence.Web, :model
  use Timex
  alias Timex.Duration
  alias DevicePresence.Device
  alias DevicePresence.Collector

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
    belongs_to :device, Device
    belongs_to :collector, Collector

    timestamps
  end

  @required_fields [:device_id, :collector_id, :event_type, :started_at, :ended_at]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
  end

  def for_device(device_id) do
    from e in __MODULE__,
      where: e.device_id == ^device_id,
      order_by: [desc: e.inserted_at]
  end

  def for_day(query, date) do
    date = Timex.parse!(date, "%Y-%m-%d", :strftime)
    IO.inspect date
    from e in query,
      where: e.inserted_at >= ^Timex.beginning_of_day(date),
      where: e.inserted_at <= ^Timex.end_of_day(date)
  end

  def most_recent(query) do
    from o in query,
      order_by: [desc: o.inserted_at],
      limit: 1
  end

  def duration(event) do
    Timex.diff(event.ended_at,event.started_at, :minutes)
  end
end
