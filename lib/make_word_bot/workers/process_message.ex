defmodule MakeWordBot.ProcessMessage do
  @moduledoc """
  This task process message in pipeline
  """
  require Logger
  
  def run(payload) do
    Logger.debug("message in the worker!!!!")
    IO.inspect(payload)
    
    message = payload["message"]
    chat = message["chat"]
    from = message["from"]
    
    # detect where is this message from
    # I really need only ID, no matter is it type "private" or "group"
    chat_id = chat["id"]
  end
end