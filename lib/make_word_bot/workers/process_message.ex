defmodule MakeWordBot.ProcessMessage do
  @moduledoc """
  This task process message in pipeline
  """
  require Logger
  
  def start(payload) do
    Logger.debug("message in the worker!!!!")
    IO.inspect(payload)
    
    message = payload["message"]
    message_id = message["message_id"]
    text = message["text"]
    chat = message["chat"]
    from = message["from"]
    
    # detect where is this message from
    # I really need only ID, no matter is it type "private" or "group"
    chat_id = chat["id"]
    
    # send answer and check result
    
    case text do
      # TODO: remove text constants from here (I'm about name)
      n when n in ["/help", "/help@make_a_word_bot"] ->
        send_message(chat_id, "Dis is a help, bro")
      n when n in ["/start", "/start@make_a_word_bot"] ->
         send_message(chat_id, "Start it, bro")
      n when n in ["/score", "/score@make_a_word_bot"] ->
        send_message(chat_id, "Yeah, dis is game score")
      _ -> send_message(chat_id, "C'mon, bro", message_id)
    end
    
  end
  
  def send_message(chat_id, text, reply_id \\ nil) do
    message = %{
      "chat_id" => chat_id,
      "text" => text,
      "reply_to_message" => reply_id,
      "disable_notifications" => true,
    } |> MakeWordBot.to_json()

    tgm_endpoint = MakeWordBot.telegram_send_message_uri()
    # sync call
    result = HTTPoison.post(tgm_endpoint, message, MakeWordBot.headers())
    Logger.debug("sent message to chat with result")
    IO.inspect result
  end
end