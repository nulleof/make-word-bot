defmodule MakeWordBot.ProcessMessage do
  @moduledoc """
  This task process message in pipeline
  """
  require Logger
  
  def run(message) do
    Logger.debug("message in the worker!!!!")
    IO.inspect(message)
  end
end