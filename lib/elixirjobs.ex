defmodule Elixirjobs do
  @moduledoc """
  Documentation for Elixirjobs.
  """

  alias Elixirjobs.Feed

  @sources [
    %{feed: "https://elixirjobs.net/rss", code: 'elixirjobs.net'},
    %{feed: "https://stackoverflow.com/jobs/feed?tl=elixir", code: 'stackoverflow'}
  ]

  @doc """
  Retrieves job posts from implemented feeds and returns
  as a list of maps
  """
  def retrieve do
    @sources
    |> Enum.map(&fetch/1)
    |> Enum.map(&extract/1)
    |> Enum.flat_map(&IO.inspect/1)
  end

  defp fetch(source) do
    Map.put(
      source,
      :response,
      HTTPoison.get!(source.feed).body
    )
  end

  defp extract(source) do
    source
    |> Feed.normalize_response()
    |> Feed.extract()
  end
end
