defmodule DevicePresence.Device do
  use DevicePresence.Web, :model

  alias DevicePresence.Event

  schema "devices" do
    field :name, :string
    field :mac_address, :string
    field :collector_id, :integer
    field :last_seen_ip, :string
    field :status, :string
    field :last_seen_at, Ecto.DateTime
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
end
