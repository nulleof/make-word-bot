defmodule MakeWordBot.Repo do
  use Ecto.Repo,
    otp_app: :make_word_bot,
    adapter: Ecto.Adapters.Postgres
end
