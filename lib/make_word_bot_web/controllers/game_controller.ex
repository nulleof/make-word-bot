defmodule MakeWordBotWeb.GameController do
  use MakeWordBotWeb, :controller

  require Logger

  def hook(conn, _params) do
    Logger.info("Here I am!")

    json(conn, MakeWordBot.to_json(%{}))
  end
end
