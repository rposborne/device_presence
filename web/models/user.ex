defmodule DevicePresence.User do
  use DevicePresence.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    has_many :devices, DevicePresence.Device
    has_many :events, through: [:devices, :events]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email])
    |> validate_required([:name, :email])
  end

  def with_recent_events(query) do
    from o in query,
      order_by: [desc: o.inserted_at],
      where: o.occured_at > ^(Timex.now |> Timex.shift( days: -7))
  end
end
