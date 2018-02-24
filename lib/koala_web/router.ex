defmodule KoalaWeb.Router do
  use KoalaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # We get CSRF exceptions if we use this in POST messages
    # should fix, but not a priority
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KoalaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", SqlController, :index
    get "/sql", SqlController, :index
    get "/sql/cubes", SqlController, :show
    post "/sql/cubes", SqlController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", KoalaWeb do
  #   pipe_through :api
  # end
end
