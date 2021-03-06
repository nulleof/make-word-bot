# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :make_word_bot,
  ecto_repos: [MakeWordBot.Repo],
  game_length:  120 * 1000,
  min_word_size: 7

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Telegram endpoint configs
config :make_word_bot, :telegram,
  endpoint: "https://api.telegram.org/bot",
  set_webhook: "setWebhook",
  send_message: "sendMessage",
  token: "AAAAAAAAA:CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
  server: "https://my.address.example.com",
  api_path: "api",
  skip_message_older: 60

import_config "telegram.secret.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
