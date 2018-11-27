defmodule PhoenixMetaTagsTest do
  use ExUnit.Case
  doctest PhoenixMetaTags
  use Phoenix.HTML
  use PhoenixMetaTags.TagView


  test "only default tags" do

    tags = %{
      title: "PhoenixTags;",
      description: "PhoenixTags Blog",
      url: "https://blog.PhoenixTags.com",
      image: "https://images.unsplash.com/"
    }

    other_tags = render_tags_other(tags)
    assert other_tags == []
  end


  test "string keys" do

    tags = %{
      "title" => "PhoenixTags;",
      "description" => "PhoenixTags Blog",
      "url" => "https://blog.PhoenixTags.com",
      "image" => "https://images.unsplash.com/"
    }

    other_tags = render_tags_other(tags)
    assert other_tags == []
  end


  test "render key string" do
    tags = %{
      title1: "PhoenixTags1"
    }

    result = tag(:meta, content: "PhoenixTags1",  property: "title1")

    assert render_tags_other(tags) == [result]

  end


  test "render long key string" do
    tags = %{
      "title1:part:abc": "PhoenixTags1"
    }

    result = tag(:meta, content: "PhoenixTags1",  property: "title1:part:abc")

    assert render_tags_other(tags) == [result]

  end


  test "render other tags with key value" do
    tags = %{
      title: "PhoenixTags;",
      title1: "PhoenixTags1;",
      title2: "PhoenixTags2;",
    }

    result1 = tag(:meta, content: "PhoenixTags1;",  property: "title1")
    result2 = tag(:meta, content: "PhoenixTags2;",  property: "title2")

    assert render_tags_other(tags) == [result1 ,result2]

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


    result1 = tag(:meta, content: "https://blog.otherurl.com",  property: "other_url")
    result2 = tag(:meta, content: "1200129192192192",  property: "fb:appid")


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


    result1 = tag(:meta, content: "PhoenixTags",  property: "title1")
    result2 = tag(:meta, content: "1200129192192192",  property: "fb:appid")
    result3 = tag(:meta, content: "video_name",  property: "fb:video:name")
    result4 = tag(:meta, content: "100",  property: "fb:video:width")
    result5 = tag(:meta, content: "200",  property: "fb:video:height")
    result6 = tag(:meta, content: "abc",  property: "fb:video")


    other_tags = render_tags_other(tags)
    assert other_tags -- [result1, result5,  result3, result4, result2, result6] == []

  end



  test "test config value" do
    tags = render_tags_all(%{})
    default_title  =  content_tag(:title, "config_title")
    default_title2 = tag(:meta, content: "config_title",  name: "title")
    og_title = tag(:meta, content: "config_title",  property: "og:title")
    twitter_title = tag(:meta, content: "config_title",  property: "twitter:title")
    twitter_title = tag(:meta, content: "abc",  property: "fb:video")

    assert Enum.member?(tags, default_title)
    assert Enum.member?(tags, default_title2)
    assert Enum.member?(tags, og_title)
    assert Enum.member?(tags, twitter_title)
  end


  test "override value" do
    tags = %{
      title: "PhoenixTags",
      og: %{
        title: "Override",
      }
    }

    og_tag = tag(:meta, content: "Override",  property: "og:title")

    tags_all = render_tags_all(tags)

    assert Enum.member?(tags_all, og_tag)
  end


end
