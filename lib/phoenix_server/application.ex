defmodule PhoenixServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixServerWeb.Telemetry,
      PhoenixServer.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixServer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixServer.Finch},
      # Start a worker by calling: PhoenixServer.Worker.start_link(arg)
      # {PhoenixServer.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
