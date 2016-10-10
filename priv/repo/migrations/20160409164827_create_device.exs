defmodule DevicePresence.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :user_id, :integer
      add :collector_id, :integer
      add :name, :string
      add :status, :string
      add :mac_address, :string
      add :last_seen_at, :datetime
      add :last_seen_ip, :string

      timestamps
    end

    create unique_index(:devices, [ :mac_address], name: :mac_address_uniq_index)

  end
end
