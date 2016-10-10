defmodule DevicePresence.Event do
  use DevicePresence.Web, :model

  schema "events" do
    field :device_id, :integer
    field :collector_id, :integer
    field :occured_at, Ecto.DateTime
    field :event_type, :string

    timestamps
  end

  @required_fields [:device_id, :collector_id, :event_type, :occured_at]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
  end
end
