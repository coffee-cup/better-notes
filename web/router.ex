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
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug JaSerializer.Deserializer
  end

  scope "/api/v1", BetterNotes do
    pipe_through :api_auth

    get "/", ApiController, :index

    resources "/users", UserController, except: [:new, :edit]
    get "/user/current", UserController, :current, as: :current_user
    delete "/logout", AuthController, :delete
  end

  scope "/api/v1/auth", BetterNotes do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", BetterNotes do
    pipe_through :browser # Use the default browser stack

    get "/*path", ElmController, :index
  end
end
