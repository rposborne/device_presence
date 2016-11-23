defmodule DevicePresence.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use DevicePresence.Web, :controller
  plug Ueberauth
  alias DevicePresence.UserFromAuth
  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user) # verify your logged in resource
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: "/locations")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
