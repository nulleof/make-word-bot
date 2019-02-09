# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MakeWordBot.Repo.insert!(%MakeWordBot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# There is some (~120k) words in vocabulary.txt here in this folder
#
# 1) Use only words without "." (skip them)
# 2) Use only words without "-" (skip them too)

defmodule Seeds do
  @moduledoc """
  This module generates initial seed for game DB
  """

  @doc """
  Init words table with vocabulary data with rules
  """
  def gen_words_from_file(filename) do
    # open file
    filepath = __ENV__.file
    |> Path.dirname
    |> Path.join(filename)

    IO.puts "Opening vocabulary on path " <> filepath

    words = File.stream!(filepath)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase(&1))
    |> Enum.filter(&Regex.match?(~r/^[а-я]+$/u, &1))

    IO.inspect(words)

    # now insert all words into the table
    Enum.each(words, &insert_line/1)
  end

  alias MakeWordBot.Word

  def insert_line(line) do
    MakeWordBot.Repo.insert(%Word{word: line}, on_conflict: :nothing)
  end
end

Seeds.gen_words_from_file "vocabulary.txt"
