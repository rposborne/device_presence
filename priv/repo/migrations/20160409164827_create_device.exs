defmodule DevicePresence.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string
      add :mac_address, :string
      add :last_seen_at, :datetime
      add :user_id, references(:posts)

      timestamps
    end

  end
end
