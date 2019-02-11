defmodule MakeWordBotWeb.Router do
  use MakeWordBotWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MakeWordBotWeb do
    pipe_through :api

    token_uri =
      Application.fetch_env!(:make_word_bot, :telegram)[:token]
      |> MakeWordBot.token_to_url()

    post "/" <> token_uri, GameController, :hook
  end
end
