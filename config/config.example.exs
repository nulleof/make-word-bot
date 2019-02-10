use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :make_word_bot, MakeWordBotWeb.Endpoint,
  secret_key_base: "generate-new-key-enough-length-64-chars"

# Configure your database
config :make_word_bot, MakeWordBot.Repo,
  username: "postgres user name",
  password: "postgres password",
  database: "db_name+_dev/_prod/_test",
  hostname: "db",
  pool_size: 15
