use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :make_word_bot, MakeWordBotWeb.Endpoint,
  https: [
    # NB: telegram only accepts 80, 88, 8080 and 8443 ports!!!
    port: 8443,
    keyfile: "priv/keys/dev.key",
    certfile: "priv/keys/dev.pem"
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

import_config "dev.secret.exs"
