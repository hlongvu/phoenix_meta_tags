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


      def render_tags_other(tags) do
          tags
          |> Map.keys()
          |> Enum.filter(fn x -> !is_default_tag(x) end)
          |> Enum.map( fn x -> {x, get_value(tags, x)} end)
          |> Map.new()
          |> render_o_tags()
      end

      defp render_o_tags(other_tags) do
        other_tags
        |> Map.keys()
        |> Enum.map(fn x -> render_o_element(x, get_value(other_tags, x)) end)
        |> List.flatten()
      end

      defp render_o_element(key, value) when is_map(value) do
         value
         |> Map.keys()
         |> Enum.map(fn x -> tag(:meta, content: value[x],  property: Atom.to_string(key) <> ":" <> Atom.to_string(x)  ) end)
      end

      defp render_o_element(key, value) do
        [tag(:meta, content: value,  property: Atom.to_string(key))]
      end


      @doc """
        Render all meta tags for default, open graph and twitter
      """
      def render_tags_all(tags) do
        render_tag_default(tags) ++ render_tag_og(tags) ++ render_tag_twitter(tags)
      end

    end
  end

end
