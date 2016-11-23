defmodule DevicePresence.Device do
  use DevicePresence.Web, :model

  alias DevicePresence.Event

  schema "devices" do
    field :name, :string
    field :mac_address, :string
    field :collector_id, :integer
    field :last_seen_ip, :string
    field :status, :string
    field :last_seen_at, Timex.Ecto.DateTime
    belongs_to :user, User
    has_many :events, Event

    timestamps
  end

  @required_fields [:mac_address, :collector_id]
  @optional_fields [:name, :last_seen_at, :last_seen_ip, :user_id, :status]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:mac_address)
    |> unique_constraint(:device, name: :mac_address_uniq_index)
  end

  def online(query) do
    from o in query,
      order_by: [desc: o.inserted_at],
      where: o.status == ^"online"
  end

  def for_user(user_id) do
    from e in __MODULE__,
      where: e.user_id == ^user_id,
      order_by: [desc: e.inserted_at]
  end

  def with_users(query) do
    from d in query,
      preload: [:user]
  end

  def with_events(query) do
    from d in query,
      preload: [:events]
  end

  def most_recent_event(device) do
    from(e in Event,
      where: e.device_id == ^device.id,
      order_by: [desc: e.inserted_at],
      limit: 1)
  end
end
