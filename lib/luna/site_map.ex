defmodule Luna.SiteMap do
  @moduledoc """
  The allowed changefreq: :always, :hourly, :daily, :weekly, :monthly, :yearly, :never
  """
  import XmlBuilder, only: [doc: 3, element: 2, element: 3]

  @default_changefreq :daily
  @default_priority 0.5

  @urlset_attributes %{
    :"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
    :"xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd",
    :"xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9",
    :"xmlns:image" => "http://www.google.com/schemas/sitemap-image/1.1",
    :"xmlns:video" => "http://www.google.com/schemas/sitemap-video/1.1",
    :"xmlns:geo" => "http://www.google.com/geo/schemas/sitemap/1.0",
    :"xmlns:news" => "http://www.google.com/schemas/sitemap-news/0.9",
    :"xmlns:mobile" => "http://www.google.com/schemas/sitemap-mobile/1.0",
    :"xmlns:pagemap" => "http://www.google.com/schemas/sitemap-pagemap/1.0",
    :"xmlns:xhtml" => "http://www.w3.org/1999/xhtml",
  }

  def write_file(file_path, url_elements) do
    # TODO(seizans): データ量が増えた場合に Stream でなんとかしたい
    content = doc(:urlset, @urlset_attributes, url_elements)
    File.write!(file_path, content, [:utf8, :write, :compressed])
  end

  def url_element(loc, lastmod, opts) do
    element(:url, %{}, [
      element(:loc, loc),
      element(:lastmod, lastmod),
      element(:changefreq, opts[:changefreq] || @default_changefreq),
      element(:priority, opts[:priority] || @default_priority),
    ])
  end
end
