defmodule PhoenixMetaTags.TagView do
  use Phoenix.HTML
  @moduledoc """
  This module render the tags struct to html meta tag.
  """

  defmacro __using__(_) do
    quote do


      @default_tags [:title, :description, :image, :url]

      defp is_default_tag(t) do
        Enum.member?(@default_tags, t) == true
      end

      defp get_value(tags, item) do
        tags[item] || Application.get_env(:phoenix_meta_tags , item)
      end

      def get_nested_value(tags, key) do
       keys = key
              |> String.split(":")
              |> Enum.map( & String.to_atom(&1))
        get_in(tags, keys)
      end

      @doc """
        Render default meta tags
      """
      def render_tag_default(tags) do
        [
          content_tag(:title,get_value(tags, :title)),
          tag(:meta, content: get_value(tags, :title),  name: "title"),
          tag(:meta, content: get_value(tags, :description), name: "description")
        ]
      end

      @doc """
        Render meta tags for open graph
      """
      def render_tag_og(tags) do
        [
          tag(:meta, content: "website",  property: "og:type"),
          tag(:meta, content: get_value(tags,:url),  property: "og:url"),
          tag(:meta, content: get_value(tags,:title),  property: "og:title"),
          tag(:meta, content: get_value(tags,:description),  property: "og:description"),
          tag(:meta, content: get_value(tags,:image),  property: "og:image")
        ]
      end

      @doc """
        Render meta tags for twitter
      """
      def render_tag_twitter(tags) do
        [
          tag(:meta, content: "summary_large_image",  property: "twitter:card"),
          tag(:meta, content: get_value(tags,:url),  property: "twitter:url"),
          tag(:meta, content: get_value(tags,:title),  property: "twitter:title"),
          tag(:meta, content: get_value(tags,:description),  property: "twitter:description"),
          tag(:meta, content: get_value(tags,:image),  property: "twitter:image")
        ]
      end

      # render other key not in default

      def render_tags_other(tags) do
          tags
          |> Map.drop(@default_tags)
          |> flatMap()
          |> Enum.reduce(%{}, fn x, acc -> Map.merge(acc, x) end)
          |> render_tags_map()
      end


      defp flatMap(map) do
        map
        |> Enum.map( fn {k,v} -> flatMapChild("", k,v) end)
        |> List.flatten()
      end

      defp flatMapChild(prefix, key, value) when is_map(value) do
        p = prefix_for(prefix, key)
        value
        |> Enum.map(fn {k,v} -> flatMapChild(p, k, v) end)
        |> List.flatten()
      end

      defp flatMapChild(prefix, key, value) do
        p = prefix_for(prefix, key)
        [%{p => value}]
      end

      defp prefix_for(prefix, key) do
        if (prefix == ""), do: Atom.to_string(key), else: prefix <> ":" <> Atom.to_string(key)
      end

      defp render_tags_map(map) do
        IO.inspect(map)
        map
        |> Enum.map(fn {k, v} -> tag(:meta, content: v, property: k) end)
      end


#      defp render_o_tags(other_tags) do
#        other_tags
#        |> Map.keys()
#        |> Enum.map(fn x -> render_o_element( "", x, get_value(other_tags, x)) end)
#        |> List.flatten()
#      end
#
#      defp render_o_element(prefix, key, value) when is_map(value) do
#        p = if (prefix == ""), do: "", else: prefix <> ":"
#
#         value
#         |> Map.keys()
#         |> Enum.map( fn x -> render_o_element(p <> Atom.to_string(key), x, value[x]) end)
#         |> List.flatten()
#      end
#
#      defp render_o_element(prefix, key, value) do
#        p = if (prefix == ""), do: "", else: prefix <> ":"
#        [tag(:meta, content: value, property: p <> Atom.to_string(key))]
#      end


      @doc """
        Render all meta tags for default, open graph and twitter
      """
      def render_tags_all(tags) do
        render_tag_default(tags) ++ render_tag_og(tags) ++ render_tag_twitter(tags)
      end

    end
  end

end
