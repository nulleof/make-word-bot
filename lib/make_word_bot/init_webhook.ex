defmodule MakeWordBot.InitWebhook do
  use Task, restart: :transient

  def start_link(_arg) do
    Task.start_link(&run/0)
  end

  require Logger

  def run do
    json_library = Application.fetch_env!(:phoenix, :json_library)
    token = Application.fetch_env!(:make_word_bot, :telegram)[:token]

    tgm_endpoint =
      Application.fetch_env!(:make_word_bot, :telegram)[:endpoint] <>
        token <>
        Application.fetch_env!(:make_word_bot, :telegram)[:set_webhook]

    app_endpoint =
      Application.fetch_env!(:make_word_bot, :telegram)[:webhook_server] <>
        MakeWordBot.token_to_url(token)

    Logger.info("Telegram token: " <> token)
    Logger.info("Application endpoint: " <> app_endpoint)

    cert_path = "priv/keys/dev.pem"

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
            Logger.info "Webhook was successfully set to " <> app_endpoint

          _ ->
            Logger.warn "Telegram api error answer, endpoint can not work"
            Logger.debug answer
        end

      other ->
        Logger.warn "Cannot set webhook"
        Logger.debug other
    end
  end
end
