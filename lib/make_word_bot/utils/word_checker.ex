defmodule MakeWordBot.WordChecker do
  def word_consist_of?("", "") do
    true
  end
  
  def word_consist_of?("", _answer_word) do
    false
  end
  
  def word_consist_of?(_main_word, "") do
    true
  end

  @doc """
  This function checks if second word consist of symbols from first word
  
  ## Examples
  
    iex> MakeWordBot.WordChecker.word_consist_of?("привет", "ухо")
    false
    
    iex> MakeWordBot.WordChecker.word_consist_of?("", "ухо")
    false
    
    iex> MakeWordBot.WordChecker.word_consist_of?("привет", "")
    true
    
    iex> MakeWordBot.WordChecker.word_consist_of?("привет", "приветик")
    false
  
    iex> MakeWordBot.WordChecker.word_consist_of?("привет", "вер")
    true
    
    iex> MakeWordBot.WordChecker.word_consist_of?("привет", "верр")
    false
  """
  def word_consist_of?(main_word, answer_word) do
    # main_word is an array of symbols
    # iterate through answer_word symbols and drop main_word symbol if exist
    
    # take first symbol from answer_word
    first_symbol = String.first(answer_word)
    # remove this first symbol
    answer_word = String.slice(answer_word, 1..-1)

    if (String.contains?(main_word, first_symbol)) do
      main_word = String.replace(main_word, first_symbol, "", global: false)
      word_consist_of?(main_word, answer_word)
    else
      false
    end
  end
end