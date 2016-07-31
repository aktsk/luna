defmodule Luna.Mixfile do
  use Mix.Project

  def project do
    [app: :luna,
     version: "0.0.1",
     elixir: "~> 1.2",
     deps: deps,
     package: package]
  end

  def application do
    [mod: {Luna, []},
     applications: [:logger, :ex_json_schema, :httpoison, :phoenix, :poison, :xml_builder]]
  end

  defp deps do
    [{:ex_json_schema, "~> 0.4"},
     {:httpoison, ">= 0.9.0"},
     {:phoenix, "~> 1.2"},
     {:poison, "~> 2.2"},
     {:xml_builder, "~> 0.0.8"}]
  end

  defp package do
    [maintainers: ["Seizan Shimazaki"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/aktsk/luna"},
     files: ~w(mix.exs README.md LICENSE lib)]
  end
end
