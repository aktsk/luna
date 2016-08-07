defmodule LunaJwtTest do
  use ExUnit.Case
  doctest Luna.JWT

  import Luna.JWT

  @secret_key "YmJkTSl46sIDlaF3VqWFXlv+1HJYP8BsrKbsdEM+1vm3aUnzLVl6N3T6WvLQ3xjT"
  @expire_in 60 * 60 * 24

  test "decoding jwt generates original user id" do
    user_id = 1
    jwt = encode(user_id, @expire_in, @secret_key)
    {:ok, %{"iss" => _issure,
            "sub" => ^user_id,
            "exp" => _expire_at} = _claims} = decode(jwt, @secret_key)
  end
end
