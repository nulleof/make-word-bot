defmodule MakeWordBot.ProcessMessage do
  @moduledoc """
  This task process message in pipeline
  """
  require Logger
  
  def start(payload) do
    Logger.debug("message in the worker!!!!")
    IO.inspect(payload)
    
    message = payload["message"]
    message_id = message["id"]
    chat = message["chat"]
    from = message["from"]
    
    # detect where is this message from
    # I really need only ID, no matter is it type "private" or "group"
    chat_id = chat["id"]
    
    # send answer and check result
    
    send_message(chat_id, "C'mon, bro", message_id)
  end
  
  def send_message(chat_id, text, reply_id) do
    message = %{
      "chat_id" => chat_id,
      "text" => text,
      "reply_to_message_id" => reply_id,
      "disable_notifications" => true,
    } |> MakeWordBot.to_json()

    tgm_endpoint = MakeWordBot.telegram_send_message_uri()
    # sync call
    result = HTTPoison.post(tgm_endpoint, message, MakeWordBot.headers())
    Logger.debug("sent message to chat with result")
    IO.inspect result
  end
end