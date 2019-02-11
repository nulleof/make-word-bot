use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :make_word_bot, MakeWordBotWeb.Endpoint, server: false

# Print only warnings and errors during test
config :logger, level: :warn

import_config "test.secret.exs"

config :make_word_bot, MakeWordBot.Repo, pool: Ecto.Adapters.SQL.Sandbox
