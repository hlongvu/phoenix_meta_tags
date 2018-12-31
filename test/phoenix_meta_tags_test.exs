defmodule PhoenixMetaTagsTest do
  use ExUnit.Case
  use PhoenixMetaTags.TagView

  import Phoenix.HTML.Tag
  doctest PhoenixMetaTags

  describe "render_tags_other/1" do
    test "does not set default tags" do
      tags = %{
        title: "PhoenixTags;",
        description: "PhoenixTags Blog",
        url: "https://blog.PhoenixTags.com",
        image: "https://images.unsplash.com/"
      }

      assert [] == render_tags_other(tags)
    end

    test "does not set default tags with string key map" do
      tags = %{
        "title" => "PhoenixTags;",
        "description" => "PhoenixTags Blog",
        "url" => "https://blog.PhoenixTags.com",
        "image" => "https://images.unsplash.com/"
      }

      assert [] == render_tags_other(tags)
    end
  end

  describe "render_tags_other/1 internal structure" do
    test "converts map with atom keys to strings" do
      tags = %{
        title1: "PhoenixTags1"
      }

      result = tag(:meta, content: "PhoenixTags1", property: "title1")

      assert render_tags_other(tags) == [result]
    end

    test "render long key string" do
      tags = %{
        "title1:part:abc": "PhoenixTags1"
      }

      result = tag(:meta, content: "PhoenixTags1", property: "title1:part:abc")

      assert render_tags_other(tags) == [result]
    end

    test "render non-default tags with key value" do
      tags = %{
        title: "PhoenixTags;",
        title1: "PhoenixTags1;",
        title2: "PhoenixTags2;"
      }

      result1 = tag(:meta, content: "PhoenixTags1;", property: "title1")
      result2 = tag(:meta, content: "PhoenixTags2;", property: "title2")

      assert render_tags_other(tags) == [result1, result2]
    end

    test "render other tags with map" do
      tags = %{
        title: "PhoenixTags;",
        description: "PhoenixTags Blog",
        url: "https://blog.PhoenixTags.com",
        image: "https://images.unsplash.com/",
        other_url: "https://blog.otherurl.com",
        fb: %{
          appid: "1200129192192192"
        }
      }

      result1 = tag(:meta, content: "https://blog.otherurl.com", property: "other_url")
      result2 = tag(:meta, content: "1200129192192192", property: "fb:appid")

      other_tags = render_tags_other(tags)
      assert other_tags == [result2, result1]
    end

    test "render nested map" do
      tags = %{
        title1: "PhoenixTags",
        fb: %{
          appid: "1200129192192192",
          video: %{
            name: "video_name",
            width: "100",
            height: "200"
          }
        },
        "fb:video": "abc"
      }

      generated_tags = [
        tag(:meta, content: "PhoenixTags", property: "title1"),
        tag(:meta, content: "1200129192192192", property: "fb:appid"),
        tag(:meta, content: "video_name", property: "fb:video:name"),
        tag(:meta, content: "100", property: "fb:video:width"),
        tag(:meta, content: "200", property: "fb:video:height"),
        tag(:meta, content: "abc", property: "fb:video")
      ]

      Enum.map(generated_tags, fn tag ->
        assert tag in render_tags_other(tags)
      end)
    end
  end

  describe "render_tags_all/1" do
    test "test config value" do
      [
        content_tag(:title, "config_title"),
        tag(:meta, content: "config_title", name: "title"),
        tag(:meta, content: "config_title", property: "og:title"),
        tag(:meta, content: "config_title", property: "twitter:title"),
        tag(:meta, content: "abc", property: "fb:video")
      ]
      |> Enum.map(fn tag ->
        tags = render_tags_all(%{})
        assert Enum.member?(tags, tag)
      end)
    end

    test "override value" do
      tags = %{
        title: "PhoenixTags",
        og: %{
          title: "Override"
        }
      }

      og_tag = tag(:meta, content: "Override", property: "og:title")

      tags_all = render_tags_all(tags)
      assert Enum.member?(tags_all, og_tag)
    end

    test "test all tags - sets defaults for all meta tags" do
      tags = %{
        title: "PhoenixTags;",
        description: "PhoenixTags Blog",
        url: "https://blog.PhoenixTags.com",
        image: "https://images.unsplash.com/"
      }

      all_tags = render_tags_all(tags)

      expected = [
        content_tag(:title, "PhoenixTags;"),
        tag(:meta, content: "PhoenixTags;", name: "title"),
        tag(:meta, content: "PhoenixTags Blog", name: "description"),
        tag(:meta, content: "website", property: "og:type"),
        tag(:meta, content: "https://blog.PhoenixTags.com", property: "og:url"),
        tag(:meta, content: "PhoenixTags;", property: "og:title"),
        tag(:meta, content: "PhoenixTags Blog", property: "og:description"),
        tag(:meta, content: "https://images.unsplash.com/", property: "og:image"),
        tag(:meta, content: "summary_large_image", property: "twitter:card"),
        tag(:meta, content: "https://blog.PhoenixTags.com", property: "twitter:url"),
        tag(:meta, content: "PhoenixTags;", property: "twitter:title"),
        tag(:meta, content: "PhoenixTags Blog", property: "twitter:description"),
        tag(:meta, content: "https://images.unsplash.com/", property: "twitter:image"),
        tag(:meta, content: "abc", property: "fb:video"),
        tag(:meta, content: "PhoenixTags", property: "title1"),
        tag(:meta, content: "1200129192192192", property: "fb:appid"),
        tag(:meta, content: "video_name", property: "fb:video:name"),
        tag(:meta, content: "100", property: "fb:video:width"),
        tag(:meta, content: "200", property: "fb:video:height"),
        tag(:meta, content: "n100", property: "fb:video:specs:north"),
        tag(:meta, content: "w200", property: "fb:video:specs:west")
      ]

      # assert all_tags -- expected == []
      Enum.map(all_tags, fn tag ->
        assert tag in expected
      end)
    end
  end
end
