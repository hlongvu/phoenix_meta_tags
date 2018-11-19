defmodule PhoenixMetaTags.TagView do
  use Phoenix.HTML
  @moduledoc """
  Documentation for PhoenixMetaTags.
  """


  defmacro __using__(_) do
    quote do

      defp get_value(tags, item) do
        tags[item] || Application.get_env(:phoenix_meta_tags , item)
      end


      def render_tag_default(tags) do
        [
          content_tag(:title,get_value(tags, :title)),
          tag(:meta, content: get_value(tags, :title),  name: "title"),
          tag(:meta, content: get_value(tags, :description), name: "description")
        ]
      end

      def render_tag_og(tags) do
        [
          tag(:meta, content: "website",  property: "og:type"),
          tag(:meta, content: get_value(tags,:url),  property: "og:url"),
          tag(:meta, content: get_value(tags,:title),  property: "og:title"),
          tag(:meta, content: get_value(tags,:description),  property: "og:description"),
          tag(:meta, content: get_value(tags,:image),  property: "og:image")
        ]
      end

      def render_tag_twitter(tags) do
        [
          tag(:meta, content: "summary_large_image",  property: "twitter:card"),
          tag(:meta, content: get_value(tags,:url),  property: "twitter:url"),
          tag(:meta, content: get_value(tags,:title),  property: "twitter:title"),
          tag(:meta, content: get_value(tags,:description),  property: "twitter:description"),
          tag(:meta, content: get_value(tags,:image),  property: "twitter:image")
        ]
      end

      def render_tags_all(tags) do
        render_tag_default(tags) ++ render_tag_og(tags) ++ render_tag_twitter(tags)
      end

    end
  end

end
