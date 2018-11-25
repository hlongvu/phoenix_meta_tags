defmodule PhoenixMetaTags.TagView do
  use Phoenix.HTML
  alias PhoenixMetaTags.MapHelper

  @moduledoc """
  This module render the tags struct to html meta tag.
  """

  @config_read Application.get_all_env(:phoenix_meta_tags)
          |> Enum.into(%{})
          |> MapHelper.flatMap()

  defmacro __using__(_) do
    quote do

      alias PhoenixMetaTags.MapHelper
      @default_tags [:title, :description, :image, :url]
      @config unquote(Macro.escape(@config_read))

      defp is_default_tag(t) do
        Enum.member?(@default_tags, t) == true
      end

      defp get_value(tags, item) do
        tags[item] || @config[Atom.to_string(item)]
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
          |> MapHelper.flatMap()
          |> render_tags_map()
      end


      defp render_tags_map(map) do
        map
        |> Enum.map(fn {k, v} -> tag(:meta, content: v, property: k) end)
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
