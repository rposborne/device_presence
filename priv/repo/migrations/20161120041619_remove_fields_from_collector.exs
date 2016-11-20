defmodule DevicePresence.Repo.Migrations.RemoveFieldsFromCollector do
  use Ecto.Migration

  def change do
    alter table(:collectors) do
      remove :location
      remove :ip
      remove :subnet
      add :type, :string
    end
  end
end
