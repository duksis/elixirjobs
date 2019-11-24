defmodule Elixirjobs.Feed do
  import SweetXml

  def extract(feed) do
    data = feed.response
    |> xpath(
      ~x"//item"l,
      title: ~x"./title/text()"s,
      url: ~x"./link/text()"s,
      date: ~x"./pubDate/text()"s,
      description: ~x"./description/text()"s,
      location: ~x"./location/text()"s,
      categories: ~x"./category/text()"sl,
      guid: ~x"./guid/text()"s
    )
    Map.put(feed, :data, data)
  end

  @doc """
  Applies fixes to invalid xml feeds

  ## Examples

    iex> Elixirjobs.Feed.normalize_response(%{response: "<guid>1</guid>"})
    %{response: "<guid>1</guid>"}

  """
  def normalize_response(%{feed: "https://elixirjobs.net/rss", response: body} = feed) do
    # https://github.com/odarriba/elixir_jobs/pull/17
    new_body = body
      |> String.replace("<link>", "<link><![CDATA[")
      |> String.replace("</link>", "]]></link>")
      |> String.replace("<guid>", "<guid><![CDATA[")
      |> String.replace("</guid>", "]]></guid>")

    Map.put(feed, :response, new_body)
  end
  def normalize_response(feed), do: feed
end
