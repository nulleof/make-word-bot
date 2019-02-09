defmodule MakeWordBotWeb.GameController do
  use MakeWordBotWeb, :controller

  def hook(conn, params) do
    json conn, params
  end
end
