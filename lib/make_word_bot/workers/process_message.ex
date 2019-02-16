defmodule MakeWordBot.ProcessMessage do
  @moduledoc """
  This task process message in pipeline
  """
  require Logger

  @doc """
  This function compares passed unix date with current date + time to die
  
  ## Example
    iex> ((DateTime.utc_now() |> DateTime.to_unix()) - 50) |>
    ...> MakeWordBot.ProcessMessage.message_too_old()
    false
    
    iex> ((DateTime.utc_now() |> DateTime.to_unix()) - 70) |>
    ...> MakeWordBot.ProcessMessage.message_too_old()
    true
  """
  def message_too_old(date) do
    current_date = DateTime.utc_now() |> DateTime.to_unix()
  
    diff = current_date - date
    Logger.debug("Message date: #{date}, current date: #{current_date}, diff: #{diff}")
  
    diff > MakeWordBot.skip_message_older()
  end

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

  def generate_and_send_message(chat_id, initial_message, message_id, _from) do
    cond do
      is_joke_time(initial_message) -> send_joke_message(chat_id, initial_message, message_id)
      initial_message -> send_message(chat_id, "Тут будет какая-то игровая логика. Курва!", message_id)
    end
  end
  
  def process_help_message(chat_id) do
    message = """
    Это бот для игры в "Словослова"
    
    В этой игре тебе нужно составить из главного слова как можно больше слов поменьше, чтобы товарищи кусали локти от зависти, какой ты эрудированный!
    
    /start - чтобы начать игру в вашем чате. Игра длится 2 минуты
    /score - чтобы показать счет в текущей игре
    /word - чтобы показать главное слово в текущей игре
    /help - чтобы показать эту подсказку еще раз
    
    Во время игры предлагайте варианты, просто отправляя их в чат. Чем длиннее слово, тем больше очков ты за него получишь! А, может, ты предпочитаешь зерг раш трехбуквенными словами? Твое дело! Побеждай и доминируй!
    """
    
    send_message(chat_id, message)
  end
  
  def process_start_message(chat_id) do
  
  end
  
  def process_score_message(chat_id) do

  end

  def process_word_message(chat_id) do

  end
  
  def process_simple_message(chat_id, message_id, text, from) do
  
  end
  
  def process_message(message) do
     message_id = message["message_id"]
     text = message["text"]
     chat = message["chat"]
     from = message["from"]
  
     # detect where is this message from
     # I really need only ID, no matter is it type "private" or "group"
     chat_id = chat["id"]
     chat_type = chat["type"]
     
     cond do
       Regex.match?(~r[^/help@make_a_word_bot], text)
       || (chat_type == "private" && Regex.match?(~r[^/help], text)) ->
         process_help_message(chat_id)
       
       Regex.match?(~r[^/start@make_a_word_bot], text)
       || (chat_type == "private" && Regex.match?(~r[^/start], text)) ->
         process_start_message(chat_id)
  
       Regex.match?(~r[^/score@make_a_word_bot], text)
       || (chat_type == "private" && Regex.match?(~r[^/score], text)) ->
         process_start_message(chat_id)
  
       Regex.match?(~r[^/word@make_a_word_bot], text)
       || (chat_type == "private" && Regex.match?(~r[^/word], text)) ->
         process_word_message(chat_id)
         
       true ->
         process_simple_message(chat_id, message_id, text, from)
     end
  end
  
  def start(payload) do
    Logger.debug("message in the worker!!!!")
    IO.inspect(payload)
    
    message = payload["message"]
    message_id = message["message_id"]
    date = message["date"]
    
    # detect where is this message from
    # I really need only ID, no matter is it type "private" or "group"
    
    cond do
      message_too_old(date) ->
        Logger.info("message #{message_id} skipped - too old")
      true ->
        process_message(message)
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
