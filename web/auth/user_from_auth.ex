defmodule DevicePresence.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  alias DevicePresence.User
  alias DevicePresence.Repo
  alias Ueberauth.Auth

  def find_or_create(%Auth{} = auth) do
    case find_by_email(auth.info.email) do
      {:ok, user} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end

  def find_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, "Could not log in."}
      user -> {:ok, user }
    end
  end

  defp basic_info(auth) do
    %{id: auth.uid, name: name_from_auth(auth), avatar: auth.info.image, email: auth.info.email}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end
end
