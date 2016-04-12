defmodule DevicePresence.Device do
  use DevicePresence.Web, :model

  schema "devices" do
    field :name, :string
    field :mac_address, :string
    field :last_seen_at, Ecto.DateTime
    field :user_id, :integer

    timestamps
  end

  @required_fields ~w(name mac_address user_id)
  @optional_fields ~w(last_seen_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
