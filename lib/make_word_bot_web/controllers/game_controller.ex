defmodule MakeWordBotWeb.GameController do
  use MakeWordBotWeb, :controller

  def hook(conn, params) do
    IO.inspect conn
    IO.inspect params
  end
end
