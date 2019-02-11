# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :make_word_bot,
  ecto_repos: [MakeWordBot.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Telegram endpoint configs
config :make_word_bot, :telegram,
  endpoint: "https://api.telegram.org/bot",
  set_webhook: "/setWebhook",
  token: "AAAAAAAAA:CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
  webhook_server: "https://my.address.example.com:8443/api/"

import_config "telegram.secret.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
