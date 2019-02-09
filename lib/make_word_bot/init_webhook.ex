defmodule MakeWordBot.InitWebhook do
  use Task, restart: :transient

  def start_link(_arg) do
    Task.start_link(&run/0)
  end

  alias MakeWordBot.Utils

  def run do
    json_library = Application.fetch_env!(:phoenix, :json_library)
    token = Application.fetch_env!(:make_word_bot, :telegram)[:token]

    IO.inspect "Telegram bot token: " <> token

    tgm_endpoint = Application.fetch_env!(:make_word_bot, :telegram_api)[:endpoint]
      <> token
      <> Application.fetch_env!(:make_word_bot, :telegram_api)[:set_webhook]

    app_endpoint = Application.fetch_env!(:make_word_bot, :telegram)[:webhook_server]
      <> Utils.token_to_url(token)

    IO.inspect "Application endpoint: " <> app_endpoint

    cert_path = Application.fetch_env!(:make_word_bot, MakeWordBotWeb.Endpoint)[:https]
    |> Keyword.fetch!(:certfile)

    IO.inspect cert_path

    body = {
      :multipart,
      [
        {
          :file,
          cert_path,
          {
            "form-data",
            [name: "certificate", filename: Path.basename(cert_path)]
          },
          []
        },
        {"url", app_endpoint}
      ]
    }

    headers = [{"Content-type", "application/json"}]

    case HTTPoison.post(tgm_endpoint, body, headers, []) do
      {:ok, response} ->
        answer = json_library.decode(response.body)
        case answer do
          {:ok, %{"ok" => true, "result" => true}} ->
            IO.puts "Webhook was successfully set to " <> app_endpoint
          _ ->
            IO.puts "Telegram api answered wrong, endpoint can not work"
            IO.inspect answer
        end
      other ->
        IO.puts "Connot set webhook"
        IO.inspect other
    end


  end
end
