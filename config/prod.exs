use Mix.Config

config :make_word_bot, MakeWordBotWeb.Endpoint,
  https: [
    :inet6,
    port: System.get_env("PORT") || 8443,
    keyfile: "priv/keys/prod.key",
    certfile: "priv/keys/prod.pem"
  ]

# Do not print debug messages in production
config :logger, level: :info

import_config "prod.secret.exs"
