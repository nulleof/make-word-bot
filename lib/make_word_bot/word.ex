defmodule MakeWordBot.Word do
  use Ecto.Schema
  import Ecto.Changeset


  schema "words" do
    field :word, :string
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:word])
    |> validate_required([:word])
    |> unique_constraint(:word)
  end
end
