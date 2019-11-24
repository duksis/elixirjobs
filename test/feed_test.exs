defmodule FeedTest do
  use ExUnit.Case

  alias Elixirjobs.Feed

  doctest Feed

  test "#normalize_response/1 - fix elixirjobs.net invalid xml" do
    feed = "https://elixirjobs.net/rss"
    invalid_body = """
    <guid>294501</guid>
    <title>Test job 3</title>
    <link>https://www.w3schools.com/xml/xml_rss.asp</link>
    """
    valid_body = """
    <guid><![CDATA[294501]]></guid>
    <title>Test job 3</title>
    <link><![CDATA[https://www.w3schools.com/xml/xml_rss.asp]]></link>
    """
    assert Feed.normalize_response(%{feed: feed, response: invalid_body}) ==
      %{feed: feed, response: valid_body}
  end

  test "#normalize_response/1 - does not touch non elixirjobs.net feeds" do
    assert Feed.normalize_response(%{response: "<guid>1</guid>"}) ==
      %{response: "<guid>1</guid>"}
  end
end
