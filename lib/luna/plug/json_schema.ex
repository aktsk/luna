defmodule Luna.Plug.JsonSchema do
  @moduledoc """
  JsonSchema による validation をかける Plug。
  validation に引っかかった場合は 400 でレスポンスをただちに返す。
  Phoenix.Controller.controller_module と action_name を使っているため、
  router.ex 内では使えず、各 controller 内で、使う action のみに対して適用する。
  """
  @behaviour Plug

  require Logger

  import Plug.Conn
  import Phoenix.Controller, only: [controller_module: 1, action_name: 1, json: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    controller = controller_module(conn)
    case Luna.JsonSchema.validate(controller, action_name(conn), conn.params) do
      :ok ->
        conn
      {:error, reasons} when is_list(reasons) ->
        # json_schema による validate で引っかかった場合はここに来る
        # TODO(seizans): reason の組み立てを精査する
        conn
        |> put_status(400)
        |> json(%{reason: to_string(Enum.map(reasons, &Tuple.to_list(&1)))})
        |> halt()
      {:error, :not_found} ->
        Logger.error("500 returned | Corresponded JSON Schema NOT FOUND")
        # XXX(seizans): 対応スキーマが無いものがあることを起動時にチェックできる方が良い
        conn
        |> put_status(500)
        |> json(%{reason: "Corresponded JSON Schema NOT FOUND"})
        |> halt()
    end
  end
end
