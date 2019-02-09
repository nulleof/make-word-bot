use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :make_word_bot, MakeWordBotWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :make_word_bot, MakeWordBot.Repo,
  username: "postgres",
  password: "postgres",
  database: "make_word_bot_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

import_config "telegram.secret.exs"
