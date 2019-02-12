defmodule MakeWordBotWeb.Router do
  use MakeWordBotWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MakeWordBotWeb do
    pipe_through :api

    post "/" <> MakeWordBot.telegram_token_uri(), GameController, :hook
  end
end
