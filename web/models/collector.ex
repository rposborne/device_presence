defmodule DevicePresence.Collector do
  use DevicePresence.Web, :model

  alias DevicePresence.Device
  schema "collectors" do
    field :name, :string
    field :location, :string
    field :ip, :string
    field :subnet, :string
    has_many :devices, Device

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
end
