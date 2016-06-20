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
    [applications: [:logger, :ex_json_schema, :phoenix, :poison]]
  end

  defp deps do
    [{:ex_json_schema, "~> 0.4"},
     {:phoenix, "~> 1.1.4"},
     {:poison, "~> 2.1"}]
  end
end
