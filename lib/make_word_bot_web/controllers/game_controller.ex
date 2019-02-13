defmodule MakeWordBotWeb.GameController do
  use MakeWordBotWeb, :controller

  require Logger

  @doc """
  Group message format:

  %{
    "message" => %{
      "chat" => %{
        "all_members_are_administrators" => true,
        "id" => -333333333,
        "title" => "ТЕСТ БОТА",
        "type" => "group"
      },
      "date" => 1550058689,
      "entities" => [
        %{
          "length" => 22,
          "offset" => 0,
          "type" => "bot_command"
        }
      ],
      "from" => %{
        "first_name" => "Name",
        "id" => 111111111,
        "is_bot" => false,
        "language_code" => "ru",
        "last_name" => "Lastname",
        "username" => "UserName"
      },
      "message_id" => 128,
      "text" => "/start@make_a_word_bot"
    },
    "update_id" => 231769956
  }

  And this for private

  %{
    "message" => %{
      "chat" => %{
        "first_name" => "Name", 
        "id" => 111111111,
        "last_name" => "Lastname",
        "type" => "private",
        "username" => "UserName"
      },
      "date" => 1549993216,
      "entities" => [
        %{
          "length" => 6,
          "offset" => 0,
          "type" => "bot_command"
        }
      ],
      "from" => %{
        "first_name" => "Name",
        "id" => 111111111,
        "is_bot" => false,
        "language_code" => "ru",
        "last_name" => "Latname",
        "username" => "UserName"
      },
      "message_id" => 118,
      "text" => "/start"
    },
    "update_id" => 231769945
  }
  """
  def hook(conn, message) do
    Logger.info("Here I am!")

    MakeWordBot.start_async(fn -> MakeWordBot.ProcessMessage.run(message) end)
    
    json(conn, MakeWordBot.to_json(%{}))
  end
end
