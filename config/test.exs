use Mix.Config

# I run server during tests, why not?
config :make_word_bot, MakeWordBotWeb.Endpoint,
  https: [
    # NB: telegram only accepts 80, 88, 8080 and 8443 ports!!!
    port: 8443, # I don't use here 4001 port
    keyfile: "priv/keys/dev.key",
    certfile: "priv/keys/dev.pem"
  ]

# Print only warnings and errors during test
config :logger, level: :warn

import_config "test.secret.exs"

config :make_word_bot, MakeWordBot.Repo, pool: Ecto.Adapters.SQL.Sandbox
