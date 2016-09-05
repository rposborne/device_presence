defmodule DevicePresence.Device do
  use DevicePresence.Web, :model

  schema "devices" do
    field :name, :string
    field :mac_address, :string
    field :fing_node, :string
    field :last_seen_ip, :string
    field :last_seen_at, Ecto.DateTime
    belongs_to :user, User
    timestamps
  end

  @required_fields ~w(mac_address fing_node)
  @optional_fields ~w(name last_seen_at last_seen_ip user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:mac_address,:fing_node], {})
    |> unique_constraint(:fing_node)
    |> unique_constraint(:mac_address)
  end
end
