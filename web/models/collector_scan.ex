defmodule DevicePresence.CollectorScan do
  use DevicePresence.Web, :model

  schema "collector_scans" do
    field :occurred_at, Timex.Ecto.DateTime
    belongs_to :collector, DevicePresence.Collector

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:occurred_at])
    |> validate_required([:occurred_at])
  end
end
