# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :make_word_bot,
  ecto_repos: [MakeWordBot.Repo]

# Configures the endpoint
config :make_word_bot, MakeWordBotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "K09+FTTwEAxOokT/1E01dzjPDM7W97JTm/y7tf02zoder8fiV/sNmG3OzGw7H3+N",
  render_errors: [view: MakeWordBotWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: MakeWordBot.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Telegram endpoint configs
config :make_word_bot, :telegram_api,
  endpoint: "https://api.telegram.org/bot",
  set_webhook: "/setWebhook"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
