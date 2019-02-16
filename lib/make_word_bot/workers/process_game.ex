defmodule MakeWordBot.ProcessGame do
  require Logger

  def send_message(chat_id, message, message_reply_id \\ nil) do
    MakeWordBot.start_async(fn ->
      MakeWordBot.ProcessMessage.send_message(chat_id, message, message_reply_id)
    end)
  end

  def start_link(chat_id) do
    # start linked (or not? It doesn't matter at all) timer here
    Process.send_after(self(), :end_game, MakeWordBot.game_length())
  
    # TODO: search here new word
    word = "выхухоль"
    message = "Начата новая игра! Слово игры **#{String.capitalize(word)}** "
    send_message(chat_id, message)
  
    # start main game loop
    game_loop(%{
      chat_id: chat_id,
      word: word,
      score: 0,
    })
  end
  
  def game_loop(state) do
    receive do
      {:end_game} ->
        # kills itself, tell about results
        Logger.info("Game was finished")
        message = "Игра закончена!"
        send_message(state.chat_id, message)
        
      {:answer, message_id, text, _from} ->
        Logger.debug("PONG!")
        message = "О, вариант ответа #{text}"
        send_message(state.chat_id, message, message_id)
        game_loop(state)
        
      {:get_word} ->
        Logger.debug("Request current word")
        message = "Текущее слово **#{String.capitalize(state.word)}**"
        send_message(state.chat_id, message)
        game_loop(state)
        
      {:score} ->
        Logger.debug("Requested current score")
        message = "Текущий счет **#{state.word}**"
        send_message(state.chat_id, message)
        game_loop(state)
    end
  end
end