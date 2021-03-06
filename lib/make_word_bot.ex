defmodule MakeWordBot do
  @moduledoc """
  MakeWordBot keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Returns using app port
  """
  def app_port do
    Application.fetch_env!(:make_word_bot, MakeWordBotWeb.Endpoint)[:https]
    |> Keyword.fetch!(:port)
  end

  @doc """
  I use app defined json library. This function returns it
  """
  def json_library do
    Application.fetch_env!(:phoenix, :json_library)
  end

  @doc """
  Returns telegram token
  """
  def telegram_token do
    Application.fetch_env!(:make_word_bot, :telegram)[:token]
  end

  @doc """
  Wrapper for json library you define in config.exs

  ## Example
    iex> MakeWordBot.to_json(%{})
    "{}"
  """
  def to_json(data) do
    data |> json_library().encode!
  end

  @doc """
  Replaces ":" in token string with "/".
  This function is required for Phoenix router error fix (can't handle ":" in uri)
  """
  def telegram_token_uri() do
    token = telegram_token()
    Regex.replace(~r/:/, token, "/")
  end

  @doc """
  Returns formed telegram endpoint
  """
  def telegram_endpoint do
    Application.fetch_env!(:make_word_bot, :telegram)[:endpoint] <> telegram_token()
  end

  @doc """
  Returns formed my webhook uri
  """
  def telegram_set_webhook_uri do
    [telegram_endpoint(), Application.fetch_env!(:make_word_bot, :telegram)[:set_webhook]]
    |> Enum.join("/")
  end

  @doc """
  Returns formed my webhook uri
  """
  def telegram_send_message_uri do
    [telegram_endpoint(), Application.fetch_env!(:make_word_bot, :telegram)[:send_message]]
    |> Enum.join("/")
  end

  def app_server do
    [Application.fetch_env!(:make_word_bot, :telegram)[:server], app_port()]
    |> Enum.join(":")
  end

  @doc """
  Returns formed uri for my webhook
  """
  def app_webhook_uri do
    [
      app_server(),
      Application.fetch_env!(:make_word_bot, :telegram)[:api_path],
      telegram_token_uri()
    ]
    |> Enum.join("/")
  end

  @doc """
  Returns certfile path defined in config https option
  """
  def certfile_path do
    Application.fetch_env!(:make_word_bot, MakeWordBotWeb.Endpoint)[:https]
    |> Keyword.fetch!(:certfile)
  end

  @doc """
  Starts async task on task supervisor
  """
  def start_async(work) do
    Task.Supervisor.async_nolink(MakeWordBot.TaskSupervisor, work)
  end
  
  @doc """
  Returns HTTPoison json headers
  """
  def headers do
    [{"Content-type", "application/json"}]
  end
  
  @doc"""
  Returns time limit for old messages
  """
  def skip_message_older do
    Application.fetch_env!(:make_word_bot, :telegram)[:skip_message_older]
  end
  
  def get_current_game(chat_id) do
    MakeWordBot.GameStoreServer.get_game(chat_id)
  end
  
  def create_new_game(chat_id) do
    MakeWordBot.GameStoreServer.start_game(chat_id)
  end
  
  def stop_game(chat_id) do
    MakeWordBot.GameStoreServer.stop_game(chat_id)
  end
  
  def game_length do
    Application.fetch_env!(:make_word_bot, :game_length)
  end
  
  def min_word_size do
    Application.fetch_env!(:make_word_bot, :min_word_size)
  end
end
