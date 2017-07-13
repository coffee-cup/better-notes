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
  end

  scope "/api", BetterNotes do
    pipe_through :api

    get "/", ApiController, :index
  end

  scope "/", BetterNotes do
    pipe_through :browser # Use the default browser stack

    get "/*path", ElmController, :index
  end
end
