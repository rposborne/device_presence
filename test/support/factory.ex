defmodule DevicePresence.Factory do
  use ExMachina.Ecto, repo: DevicePresence.Repo

  alias DevicePresence.User

  def factory(:user) do
    %User{
      id: sequence(:id, &(&1)),
      name: "Bob Belcher",
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end
end
