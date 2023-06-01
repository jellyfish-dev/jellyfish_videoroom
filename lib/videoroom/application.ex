defmodule Videoroom.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ets.new(:room_table, [:named_table, :set, :public])

    children = [
      # Start the Telemetry supervisor
      VideoroomWeb.Telemetry,
      # Registry and Supervisor, which manage Meetings
      {Registry, keys: :unique, name: Videoroom.Registry},
      {DynamicSupervisor, name: Videoroom.MeetingSupervisor},
      # Start the PubSub system
      {Phoenix.PubSub, name: Videoroom.PubSub},
      # Start the Endpoint (http/https)
      VideoroomWeb.Endpoint
      # Start a worker by calling: Videoroom.Worker.start_link(arg)
      # {Videoroom.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Videoroom.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VideoroomWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
