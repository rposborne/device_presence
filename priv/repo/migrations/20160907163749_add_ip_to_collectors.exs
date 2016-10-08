defmodule DevicePresence.Repo.Migrations.AddIpToCollectors do
  use Ecto.Migration

  def change do
    alter table(:collectors) do
      add :ip, :string
    end
  end
end
