Luna
====

Utility library for Elixir.


## Installation

Add Luna to `mix.exs` dependencies:


## Luna.SiteMap

Usage example:

```
defmodule MyApp.SiteMap do
  alias MyApp.{Article, Repo, User}

  def refresh() do
    now = DateTime.utc_now()
          |> DateTime.to_iso8601()
    url_elements = [url_elem("/top", now, %{changefreq: :hourly, priority: 1.0})]
                   ++ (Repo.all(User) |> Enum.map(&user_url_element/1))
                   ++ (Repo.all(Article) |> Enum.map(&article_url_element/1))
    Application.app_dir(:my_app, "priv/static")
    |> Path.join("site_map.xml.gz")
    |> Luna.SiteMap.write_file(url_elements)
  end

  defp url_elem(path, lastmod, opts \\ %{}) do
    host = Application.fetch_env!(:my_app, MyApp.Endpoint)[:url][:host]
    uri = %URI{scheme: "https", host: host, path: path}
          |> URI.to_string()
    Luna.SiteMap.url_element(uri, lastmod, opts)
  end

  defp user_url_element(user) do
    url_elem(Path.join("/users", to_string(user.id)), Ecto.DateTime.to_iso8601(user.updated_at))
  end

  defp article_url_element(article) do
    url_elem(Path.join("/articles", to_string(article.id)), Ecto.DateTime.to_iso8601(article.updated_at))
  end
end
```
