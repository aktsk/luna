defmodule Luna.Mixfile do
  use Mix.Project

  def project do
    [app: :luna,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:logger, :ex_json_schema, :phoenix, :poison]]
  end

  defp deps do
    [{:ex_json_schema, "~> 0.4"},
     {:phoenix, "~> 1.2.0-rc"},
     {:poison, "~> 2.1"}]
  end

  defp package do
    [maintainers: ["Seizan Shimazaki"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/aktsk/luna"},
     files: ~w(mix.exs README.md LICENSE lib)]
  end
end
