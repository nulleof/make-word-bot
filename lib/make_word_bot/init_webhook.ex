defmodule MakeWordBot.InitWebhook do
  use Task, restart: :transient

  def start_link(_arg) do
    Task.start_link(&run/0)
  end

  def run do
    json_library = Application.fetch_env!(:phoenix, :json_library)
    token = Application.fetch_env!(:make_word_bot, :telegram)[:token]

    IO.inspect "Telegram bot token: " <> token

    tgm_endpoint = Application.fetch_env!(:make_word_bot, :telegram_api)[:endpoint]
      <> token
      <> Application.fetch_env!(:make_word_bot, :telegram_api)[:set_webhook]

    app_endpoint = Application.fetch_env!(:make_word_bot, :telegram)[:webhook_server]
      <> token

    IO.inspect "Application endpoint: " <> app_endpoint

    body = %{
      "url" => app_endpoint
    } |> json_library.encode!()

    headers = [{"Content-type", "application/json"}]

    {:ok, response} = HTTPoison.post(tgm_endpoint, body, headers, [])

    answer = json_library.decode(response.body)

    case answer do
      {:ok, %{"ok" => true, "result" => true}} ->
        IO.puts "Webhook was successfully set to " <> app_endpoint
      true ->
        IO.puts "Telegram api answered wrong, endpoint can not work"
        IO.inspect answer
    end
  end
end
