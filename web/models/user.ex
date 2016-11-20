defmodule DevicePresence.User do
  use DevicePresence.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :slack_mention_name, :string
    field :slack_user_id, :string
    field :github_username, :string
    
    has_many :devices, DevicePresence.Device
    has_many :events, through: [:devices, :events]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :slack_mention_name, :slack_user_id, :github_username])
    |> validate_required([:name])
  end

  def with_recent_events(query) do
    from o in query,
      order_by: [desc: o.inserted_at],
      where: o.updated_at > ^(Timex.now |> Timex.shift( days: -7))
  end

end
