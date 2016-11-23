defmodule DevicePresence.Router do
  use DevicePresence.Web, :router
  require Ueberauth

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

  pipeline :probes do
    plug :accepts, ["json"]
    plug DevicePresence.TokenAuth
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :requires_user do
    plug Guardian.Plug.EnsureAuthenticated, handler: DevicePresence.UnauthenticatedHandler
  end


  scope "/auth", DevicePresence do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/", DevicePresence do
    pipe_through [:browser, :browser_auth]
    get "/", PageController, :index
  end

  scope "/", DevicePresence do
    pipe_through [:browser, :browser_auth, :requires_user]
    resources "/users", UserController
    resources "/devices", DeviceController

    resources "/locations", LocationController do
      resources "/collectors", CollectorController, only: [:index, :new, :create]
    end
    resources "/collectors", CollectorController, except: [:index, :new, :create], as: :location_collector

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

    resources "/events", EventController, except: [:new, :edit]
    get "/events/for/:for_date", EventController, :for_date


    post "/devices/scan", ScanController, :create

  end
  scope "/probes", DevicePresence do
    pipe_through :probes
    post "/collectors/report", ScanController, :create
  end
end
