defmodule MakeWordBot.Utils do
  @moduledoc """
  This module holds additional helpful functions
  """

  @doc """
  Replaces ":" in token string with "/".
  This function is required for Phoenix router error fix (can't handle ":" in uri)

  ## Examples

    iex> MakeWordBot.Utils.token_to_url("AAAAAAAA:CCCCCCCCCCCCC")
    "AAAAAAAA/CCCCCCCCCCCCC"
  """
  def token_to_url(token) do
    Regex.replace(~r/:/, token, "/")
  end
end
