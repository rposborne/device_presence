defmodule DevicePresence.Router do
  use DevicePresence.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DevicePresence do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end

  # Other scopes may use custom stacks.
  scope "/api", DevicePresence do
    pipe_through :api

    resources "/devices", DeviceController, except: [:new, :edit]
    resources "/nodes", NodeController, only: [:index]
  end
end
