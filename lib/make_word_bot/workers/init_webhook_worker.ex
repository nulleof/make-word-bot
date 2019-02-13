defmodule MakeWordBot.InitWebhookWorker do
  @moduledoc """
  This task sends request to telegram
  """
  use Task, restart: :transient

  def start_link(_arg) do
    Task.start_link(&run/0)
  end

  require Logger

  def run do
    json_library = MakeWordBot.json_library()
    token = MakeWordBot.telegram_token()
    tgm_endpoint = MakeWordBot.telegram_set_webhook_uri()
    app_endpoint = MakeWordBot.app_webhook_uri()
    cert_path = MakeWordBot.certfile_path()

    Logger.info("Telegram token: " <> token)
    Logger.info("Application endpoint: " <> app_endpoint)

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
            Logger.info("Webhook was successfully set to " <> app_endpoint)

          other ->
            Logger.warn("Telegram api error answer, endpoint can not work")
            Logger.debug("Answer received: #{inspect(other)}")
        end

      other ->
        Logger.warn("Bad response")
        Logger.debug("Answer received: #{inspect(other)}")
    end
  end
end
