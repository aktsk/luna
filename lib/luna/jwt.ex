defmodule Luna.JWT do
  # TODO(seizans): 必須 config を事前チェックする仕組みを入れる
  defp fetch_secret_key!(), do: Luna.Config.fetch!(:luna, :secret_key)

  def encode(user_id, expire_in) do
    encode(user_id, expire_in, fetch_secret_key!())
  end

  def encode(user_id, expire_in, secret_key) do
    alg = "HS512"
    expire_at = timestamp() + expire_in
    header = %{"typ" => "JWT",
               "alg" => alg}
    claims = %{"iss" => "Luna",
               "sub" => user_id,
               "exp" => expire_at}
    encoded_header = header
                     |> Poison.encode!()
                     |> Base.url_encode64()
    encoded_claims = claims
                     |> Poison.encode!()
                     |> Base.url_encode64()
    signature = jwt_sign(alg, "#{encoded_header}.#{encoded_claims}", secret_key)
    "#{encoded_header}.#{encoded_claims}.#{signature}"
  end

  defp jwt_sign("HS512", payload, secret_key) do
    Base.url_encode64(:crypto.hmac(:sha512, secret_key, payload))
  end

  def decode(jwt) do
    decode(jwt, fetch_secret_key!())
  end

  def decode(jwt, secret_key) do
    alg = "HS512"
    case String.split(jwt, ".") do
      [encoded_header, encoded_claims, signature] ->
        if valid_signature?(alg, "#{encoded_header}.#{encoded_claims}", secret_key, signature) do
          _header = encoded_header
                    |> Base.url_decode64!()
                    |> Poison.decode!()
          # TODO(seizans): validate_expiry する
          claims = encoded_claims
                   |> Base.url_decode64!()
                   |> Poison.decode!()
          {:ok, claims}
        else
          {:error, :invalid_jwt}
        end
      _other ->
        {:error, :invalid_jwt}
    end
  end

  defp valid_signature?(alg, payload, key, signature) do
    jwt_sign(alg, payload, key) == signature
  end

  defp timestamp do
    {mega_sec, sec, _micro_sec} = :os.timestamp()
    mega_sec * 1_000_000 + sec
  end
end
