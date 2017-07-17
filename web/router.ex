defmodule BetterNotes.Router do
  use BetterNotes.Web, :router

  import BetterNotes.UserPlug

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

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated, handler: BetterNotes.AuthController
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureResource, handler: BetterNotes.AuthController
    plug :load_user
  end

  # Authenticated routes
  scope "/api/v1", BetterNotes do
    pipe_through :api_auth

    get "/", ApiController, :index

    get "/users", UserController, :show
    resources "/projects", ProjectController, except: [:new, :edit]
  end

  # Unauthenticated Routes
  scope "/api/v1/auth", BetterNotes do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", BetterNotes do
    pipe_through :browser # Use the default browser stack

    get "/*path", ElmController, :index
  end
end
