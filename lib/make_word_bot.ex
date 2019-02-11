defmodule MakeWordBot do
  @moduledoc """
  MakeWordBot keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Replaces ":" in token string with "/".
  This function is required for Phoenix router error fix (can't handle ":" in uri)

  ## Examples

    iex> MakeWordBot.token_to_url("AAAAAAAA:CCCCCCCCCCCCC")
    "AAAAAAAA/CCCCCCCCCCCCC"
  """
  def token_to_url(token) do
    Regex.replace(~r/:/, token, "/")
  end
end
