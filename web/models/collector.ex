defmodule DevicePresence.Collector do
  use DevicePresence.Web, :model

  schema "collectors" do
    field :name, :string
    field :type, :string
    field :api_key, :string
    belongs_to :location, DevicePresence.Location
    has_many :events, DevicePresence.Event
    has_many :devices, through: [:events, :device]
    has_many :users, through: [:devices, :user]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :location_id, :type])
    |> validate_required([:name, :type, :location_id])
  end

  def online_users(collector) do
    from u in DevicePresence.User,
      join: d in assoc(u, :devices),
      join: e in assoc(u, :events),
      distinct: u.id,
      where: d.status == ^"online",
      where:  e.collector_id == ^collector.id,
      where: e.started_at <= ^(Timex.now |> Timex.beginning_of_day),
      order_by: [desc: e.updated_at],
      select: {u.id, u.name, d.last_seen_at, e.started_at, e.ended_at}
  end

end
