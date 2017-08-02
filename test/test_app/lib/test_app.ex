defmodule TestApp do
  use Application
  import Supervisor.Spec, warn: false
  require Logger


  @defaults %{port: 4000}

  def start(_type, _args) do
    Logger.info("Application running on port #{port()}")
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, TestApp.Router, [], [port: port()])
    ]

    opts = [strategy: :one_for_one, name: TestApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port, do: Application.get_env(:test_app, :port) |> port
  defp port({:system, var}), do: var |> System.get_env |> Integer.parse |> elem(0)
  defp port(p) when is_integer(p), do: p
  defp port(_), do: @defaults.port
end
