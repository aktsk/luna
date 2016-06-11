defmodule Luna.Mixfile do
  use Mix.Project

  def project do
    [app: :luna,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :poison]]
  end

  defp deps do
    [{:poison, "~> 2.1"}]
  end
end
