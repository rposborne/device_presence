defmodule DevicePresence.Location do
  use DevicePresence.Web, :model

  schema "locations" do
    field :name, :string
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :postal_code, :string
    field :country, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :address_1, :address_2, :city, :state, :postal_code, :country])
    |> validate_required([:name])
  end
end
