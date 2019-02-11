use Mix.Config

# Configure your database
config :make_word_bot, MakeWordBot.Repo,
  username: "postgres user name",
  password: "postgres password",
  database: "db_name+_dev/_prod/_test",
  hostname: "db",
  pool_size: 15
