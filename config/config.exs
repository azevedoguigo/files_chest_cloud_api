# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :files_chest_cloud_api,
  ecto_repos: [FilesChestCloudApi.Repo]

# Configures the endpoint
config :files_chest_cloud_api, FilesChestCloudApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FilesChestCloudApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: FilesChestCloudApi.PubSub,
  live_view: [signing_salt: "eBC5+rwg"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :files_chest_cloud_api, FilesChestCloudApi.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE"]

# Guardian configuration.
config :files_chest_cloud_api, FilesChestCloudApiWeb.Auth.Guardian,
  issuer: "files_chest_cloud_api",
  secret_key: System.get_env("AUTH_SECRET_KEY")

config :files_chest_cloud_api, FilesChestCloudApiWeb.Auth.Pipeline,
  module: FilesChestCloudApiWeb.Auth.Guardian,
  error_handler: FilesChestCloudApiWeb.Auth.AuthErrorHandler

# ExAws
config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "sa-east-1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
