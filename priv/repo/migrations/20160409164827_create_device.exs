defmodule DevicePresence.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string
      add :fing_node, :string
      add :mac_address, :string
      add :last_seen_at, :datetime
      add :last_seen_ip, :string
      add :user_id, :integer

      timestamps
    end

  end
end
