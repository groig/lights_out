defmodule LightsOut.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LightsOutWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LightsOut.PubSub},
      # Start the Endpoint (http/https)
      LightsOutWeb.Endpoint,
      # Start a worker by calling: LightsOut.Worker.start_link(arg)
      # {LightsOut.Worker, arg}
      {LightsOut.LightsState, name: LightsOut.LightsState},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LightsOut.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LightsOutWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
