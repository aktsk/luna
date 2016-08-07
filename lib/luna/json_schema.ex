defmodule Luna.JsonSchema do
  @moduledoc """
  start_link 時に priv/json_schema/ 以下の .json ファイルからスキーマを ets に読み込む。
  ファイルを priv/json_schema/app_name/v1/user_controller/update.json とすると、
  ets の key は {"app_name/v1/user_controller", :update} となる。
  対応する action は AppName.V1.UserController.update となる。
  """

  @table_name :luna_json_schema_ets

  def start_link(app_name) do
    Agent.start_link(fn -> init(app_name) end)
  end

  defp init(app_name) do
    :ets.new(@table_name, [:set, :public, :named_table])
    base_dir = Application.app_dir(app_name, "priv/json_schema")
    json_files = Path.join(base_dir, "**/*.json")
                 |> Path.wildcard()
    for file <- json_files do
      controller_module = Path.dirname(file)
                          |> Path.relative_to(base_dir)
      action_name = Path.basename(file, ".json")
                    |> String.to_atom()
      key = {controller_module, action_name}
      schema = file
               |> File.read!()
               |> Poison.decode!()
               |> ExJsonSchema.Schema.resolve()
      :ets.insert(@table_name, {key, schema})
    end
    :ok
  end

  def validate(controller_module, action_name, params) do
    key = {Macro.underscore(controller_module), action_name}
    case :ets.lookup(@table_name, key) do
      [{^key, schema}] ->
        ExJsonSchema.Validator.validate(schema, params)
      [] ->
        {:error, :not_found}
    end
  end
end
