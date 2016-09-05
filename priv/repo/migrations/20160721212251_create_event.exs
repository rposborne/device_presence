defmodule DevicePresence.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :node_id, :integer
      add :prev_node_id, :integer
      add :event_type, :string
      add :occured_at, :datetime

      timestamps
    end

  end
end
