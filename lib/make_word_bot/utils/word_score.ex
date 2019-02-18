defmodule MakeWordBot.WordScore do
  def fibo(1) do
    1
  end
  
  def fibo(2) do
    2
  end
  
  def fibo(n) do
    fibo(n - 1) + fibo(n - 2)
  end
  
  def score(word) do
    length = String.length(word)
    
    fibo(length)
  end
end