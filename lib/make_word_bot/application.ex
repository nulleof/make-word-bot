defmodule MakeWordBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      MakeWordBot.Repo,
      # Start the endpoint when the application starts
      MakeWordBotWeb.Endpoint,
      # Starts a worker by calling: MakeWordBot.Worker.start_link(arg)
      # {MakeWordBot.Worker, arg},
      MakeWordBot.InitWebhookWorker,
      # Start task supervisor
      {Task.Supervisor, name: MakeWordBot.TaskSupervisor},
      # Start current games supervisor
      {Task.Supervisor, name: MakeWordBot.GameSupervisor},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MakeWordBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MakeWordBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
