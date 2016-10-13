defmodule Luna.Config do
  @moduledoc """
  Config wrapper to use environment variable inspired by
  https://gist.github.com/bitwalker/a4f73b33aea43951fe19b242d06da7b9
  """

  @spec fetch!(atom, atom) :: any
  def fetch!(app, key) when is_atom(app) and is_atom(key) do
    case Application.fetch_env!(app, key) do
      {:system, env_var} ->
        case System.get_env(env_var) do
          nil ->
            raise "Environment variable #{env_var} is necessary"
          val ->
            val
        end
      val ->
        val
    end
  end

  @spec get(atom, atom, any) :: any
  def get(app, key, default \\ nil) when is_atom(app) and is_atom(key) do
    case Application.get_env(app, key) do
      {:system, env_var} ->
        case System.get_env(env_var) do
          nil ->
            default
          val ->
            val
        end
      nil ->
        default
      val ->
        val
    end
  end

  @spec fetch_integer!(atom, atom) :: integer
  def fetch_integer!(app, key) do
    case fetch!(app, key) do
      n when is_integer(n) ->
        n
      val ->
        case Integer.parse(val) do
          {n, _} ->
            n
          :error ->
            raise "Config value {#{app}, #{key}} must be an integer"
        end
    end
  end

  @spec get_integer(atom, atom, integer | nil) :: integer | nil
  def get_integer(app, key, default \\ nil) do
    case get(app, key) do
      nil ->
        default
      n when is_integer(n) ->
        n
      val ->
        case Integer.parse(val) do
          {n, _} ->
            n
          :error ->
            raise "Config value {#{app}, #{key}} must be an integer"
        end
    end
  end
end
