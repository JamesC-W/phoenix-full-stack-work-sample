defmodule Fly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      #Fly.Repo,
      # Start the Telemetry supervisor
      FlyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Fly.PubSub},
      # Start the Endpoint (http/https)
      FlyWeb.Endpoint,
      # Start a worker by calling: Fly.Worker.start_link(arg)
      # {Fly.Worker, arg}

      Fly.Periodically
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fly.Supervisor]
    Logger.info("CHILDREN: #{inspect(children)}")
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FlyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
