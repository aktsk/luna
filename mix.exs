defmodule Luna.Mixfile do
  use Mix.Project

  def project do
    [app: :luna,
     version: "0.3.0",
     elixir: "~> 1.3",
     deps: deps(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Utility library for Elixir.",
     package: package()]
  end

  def application do
    [applications: [:logger, :ex_json_schema, :phoenix, :poison, :xml_builder]]
  end

  defp deps do
    [{:ex_json_schema, "~> 0.5"},
     {:phoenix, "~> 1.2"},
     {:poison, "~> 2.2"},
     {:xml_builder, "~> 0.0.8"},
     {:credo, "~> 0.4.12", only: [:dev, :test]}]
  end

  defp package do
    [maintainers: ["Seizan Shimazaki"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/aktsk/luna"},
     files: ~w(mix.exs README.md LICENSE lib)]
  end
end
