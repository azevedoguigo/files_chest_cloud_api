defmodule FilesChestCloudApiWeb.Router do
  use FilesChestCloudApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug FilesChestCloudApiWeb.Auth.Pipeline
  end

  scope "/api", FilesChestCloudApiWeb do
    pipe_through :api

    post "/users", UsersController, :create
    post "/users/signin", UsersController, :sign_in
  end

  scope "/api", FilesChestCloudApiWeb do
    pipe_through [:api, :auth]

    get "/users", UsersController, :get_by_id
    put "/users", UsersController, :update
    delete "/users", UsersController, :delete

    # Cloud endpoints
    get "/cloud/get-file-info", FilesCloudController, :get_file_info
    get "/cloud/list-files", FilesCloudController, :list_files
    get "/cloud/download", FilesCloudController, :download
    post "/cloud/upload", FilesCloudController, :upload
    delete "/cloud/delete-file", FilesCloudController, :delete
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: FilesChestCloudApiWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
