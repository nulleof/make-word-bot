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
    telegram_endpoint() <>
    Application.fetch_env!(:make_word_bot, :telegram)[:set_webhook]
  end
  
  def app_server do
    [Application.fetch_env!(:make_word_bot, :telegram)[:server], app_port()]
    |> Enum.join ":"
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
    |> Enum.join "/"
  end

  @doc """
  Returns certfile path defined in config https option
  """
  def certfile_path do
    Application.fetch_env!(:make_word_bot, MakeWordBotWeb.Endpoint)[:https]
    |> Keyword.fetch!(:certfile)
  end

end
