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
    resources "/users", UserController
    resources "/devices", DeviceController
    resources "/collectors", CollectorController
    get "/collectors/:id/online_users", CollectorController, :show_online
  end

  # Other scopes may use custom stacks.
  scope "/api", DevicePresence do
    pipe_through :api

    resources "/devices", DeviceApiController do
      resources "/events", EventController, except: [:new, :edit]
      get "/events/for/:for_date", EventController, :for_date
    end

    resources "/users", UserController do
      resources "/devices", DeviceApiController
    end


    post "/devices/scan", ScanController, :create
  end
end
