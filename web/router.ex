defmodule BetterNotes.Router do
  use BetterNotes.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    # plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug JaSerializer.Deserializer
  end

  scope "/api/v1", BetterNotes do
    pipe_through :api

    get "/", ApiController, :index

    resources "/users", UserController, only: [:show, :create]
  end

  scope "/", BetterNotes do
    pipe_through :browser # Use the default browser stack

    get "/*path", ElmController, :index
  end
end
