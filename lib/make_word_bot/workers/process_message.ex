defmodule MakeWordBot.ProcessMessage do
  @moduledoc """
  This task process message in pipeline
  """
  require Logger

  def is_joke_time(word) do
    Regex.match?(~r/иста$/ui, word)
      || Regex.match?(~r/ет$/ui, word)
  end

  def send_joke_message(chat_id, initial_message, message_id) do
    answer = cond do
      Regex.match?(~r/иста$/ui, initial_message) -> "Отсоси у тракториста"
      Regex.match?(~r/ет$/ui, initial_message) -> "Пидора ответ"
    end

    send_message(chat_id, answer, message_id)
  end

  def generate_and_send_message(chat_id, initial_message, message_id) do
    cond do
      is_joke_time(initial_message) -> send_joke_message(chat_id, initial_message, message_id)
      initial_message -> send_message(chat_id, "Тут будет какая-то игровая логика. Курва!", message_id)
    end
  end

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

      word -> generate_and_send_message(chat_id, word, message_id)

      _ -> send_message(chat_id, "C'mon, bro", message_id)
    end

  end

  def send_message(chat_id, text, reply_id \\ nil) do
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
