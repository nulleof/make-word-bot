defmodule MakeWordBot.ProcessGame do
  require Logger

  alias MakeWordBot.Repo
  
  def send_message(chat_id, message, message_reply_id \\ nil) do
    MakeWordBot.start_async(fn ->
      MakeWordBot.ProcessMessage.send_message(chat_id, message, message_reply_id)
    end)
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
  
  def perform_joke(chat_id, text, message_id) do
    cond do
      is_joke_time(text) -> send_joke_message(chat_id, text, message_id)
      
      true -> :not_a_joke
    end
  end
  
  import Ecto.Query
  
  def gen_main_word() do
    word = Repo.all(from w in MakeWordBot.Word)
      |> Enum.filter(fn word -> String.length(word.word) >= MakeWordBot.min_word_size() end)
      |> Enum.random()
    
    word.word
  end

  def word_exists_in_db?(word) do
    query = from w in MakeWordBot.Word,
      where: w.word == ^word
    
    count_entries = Repo.all(query)
    |> Enum.count()
    
    count_entries > 0
  end

  def start_link(chat_id) do
    # start linked (or not? It doesn't matter at all) timer here
    Logger.debug("New game started with pid: #{inspect self()}")
    Process.send_after(self(), {:end_game}, MakeWordBot.game_length())
  
    # search here new word
    word = gen_main_word()
    
    message = "Начата новая игра! Слово игры *#{String.upcase(word)}* "
    send_message(chat_id, message)
  
    # start main game loop
    game_loop(%{
      chat_id: chat_id,
      word: word,
      answers: %{},
      score: %{},
    })
  end
  
  def update_score(score, user_name, user_id, amount) do
    user_score = Map.get(score, user_id)
    
    if (user_score == nil) do
      Map.put(score, user_id, %{
        score: amount,
        name: user_name,
      })
    else
      old_score = user_score.score
      user_score = Map.put(user_score, :score, old_score + amount)
      Map.put(score, user_id, user_score)
    end
  end
  
  import MakeWordBot.WordChecker, only: [word_consist_of?: 2]
  
  def process_answer(message_id, answer, from, state) do
    answer_prepared = answer
      |> String.downcase()
      |> String.trim()
    
    game_word = state.word
    
    case Map.get(state.answers, answer_prepared) do
      true ->
        # do nothing, word was already answered
        state
        
      nil ->
        cond do
          game_word == answer_prepared ->
            message = "Молодец! Возьми с полки пирожок, +0. *#{String.upcase(state.word)}*"
            send_message(state.chat_id, message, message_id)
            state
          
          word_consist_of?(game_word, answer_prepared) && word_exists_in_db?(answer_prepared) ->
            # add to list of known entries
            answers = Map.put(state.answers, answer_prepared, true)
            
            user_name = "#{from["first_name"]} #{from["last_name"]}"
            user_id = from["id"]
            
            # update score for user
            score_for_word = MakeWordBot.WordScore.score(answer_prepared)
            score = update_score(state.score, user_name, user_id, score_for_word)
            
            state = Map.put(state, :score, score)
            state = Map.put(state, :answers, answers)
            
            # send hooray message
            message = "+#{score_for_word} #{user_name}. *#{String.upcase(state.word)}*"
            send_message(state.chat_id, message, message_id)
            state
            
          true ->
            state
        end
      
      _ -> state
    end
  end
  
  def score_message(chat_id, score) do
    message = "Счет:\n"
    
    Enum.reduce(score, message, fn ({k, v}, acc) ->
      acc <> "#{v.score} | #{v.name}\n"
    end)
  end
  
  def game_loop(state) do
    receive do
      {:end_game} ->
        # kills itself, tell about results
        Logger.info("Game was finished")
        message = "*Игра закончена!*\n" <> score_message(state.chat_id, state.score)
        send_message(state.chat_id, message)
        
      {:answer, message_id, text, from} ->
        Logger.debug("PONG!")
        
        # send a joke first
        perform_joke(state.chat_id, text, message_id)
        
        state = process_answer(message_id, text, from, state)
        
        game_loop(state)
        
      {:get_word} ->
        Logger.debug("Request current word")
        message = "Текущее слово *#{String.upcase(state.word)}*"
        send_message(state.chat_id, message)
        game_loop(state)
        
      {:score} ->
        Logger.debug("Requested current score")
        message = score_message(state.chat_id, state.score)
        send_message(state.chat_id, message)
        game_loop(state)
    end
  end
end