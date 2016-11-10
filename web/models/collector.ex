defmodule DevicePresence.Collector do
  use DevicePresence.Web, :model

  alias DevicePresence.Event
  alias DevicePresence.User

  schema "collectors" do
    field :name, :string
    field :location, :string
    field :ip, :string
    field :subnet, :string
    # has_many :devices, Device

    has_many :events, Event
    has_many :devices, through: [:events, :device]
    has_many :users, through: [:devices, :user]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :location, :subnet, :ip])
    |> validate_required([:name, :ip])
  end

  def online_users(collector) do
    from u in User,
      join: d in assoc(u, :devices),
      join: e in assoc(u, :events),
      distinct: u.id,
      where: d.status == ^"online",
      where:  e.collector_id == ^collector.id,
      where: e.started_at <= ^(Timex.now |> Timex.beginning_of_day),
      order_by: [desc: e.updated_at],
      select: {u.name, d.last_seen_at, e.started_at, e.ended_at}
  end

end
