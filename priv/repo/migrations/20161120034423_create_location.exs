defmodule DevicePresence.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :address_1, :string
      add :address_2, :string
      add :city, :string
      add :state, :string
      add :postal_code, :string
      add :country, :string

      timestamps()
    end

  end
end
