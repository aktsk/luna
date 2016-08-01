defmodule Luna.Slack do
  # TODO(seizans): notify の error 時にリトライするようにする
  @spec async_notify(binary(), binary(), map()) :: term()
  def async_notify(token, text, opts \\ %{}) do
    Task.Supervisor.start_child(Luna.Slack.Supervisor, fn -> notify(token, text, opts) end)
  end

  @doc """
  ## Options

  * `:channel`
  * `:username`
  * `:icon_emoji`
  """
  @spec notify(binary(), binary(), map()) :: term()
  def notify(token, text, opts \\ %{}) do
    uri = %URI{scheme: "https",
               host: "hooks.slack.com",
               path: Path.join("/services", token)}
    body = opts
           |> Map.put(:text, text)
           |> Poison.encode!()
    case HTTPoison.post(uri, body) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        :ok
      {:ok, %HTTPoison.Response{} = response} ->
        {:error, response}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
