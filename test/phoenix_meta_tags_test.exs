defmodule PhoenixMetaTagsTest do
  use ExUnit.Case
  doctest PhoenixMetaTags
  use Phoenix.HTML
  use PhoenixMetaTags.TagView


  test "only default tags" do

    tags = %{
      title: "hlongvu;",
      description: "Hlongvu Blog",
      url: "https://blog.hlongvu.com",
      image: "https://images.unsplash.com/photo-1519337265831-281ec6cc8514?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e0604c8783c88d26ff2b89c3fc0ac137&auto=format&fit=crop&w=1500&q=80"
    }

    other_tags = render_tags_other(tags)
    assert other_tags == []
  end


  test "render key string" do
    tags = %{
      "title1": "hlongvu1"
    }

    result = tag(:meta, content: "hlongvu1",  property: "title1")

    assert render_tags_other(tags) == [result]

  end


  test "render other tags with key value" do
    tags = %{
      title: "hlongvu;",
      title1: "hlongvu1;",
      title2: "hlongvu2;",
    }

    result1 = tag(:meta, content: "hlongvu1;",  property: "title1")
    result2 = tag(:meta, content: "hlongvu2;",  property: "title2")

    assert render_tags_other(tags) == [result1 ,result2]

  end

  test "render other tags with map" do

    tags = %{
      title: "hlongvu;",
      description: "Hlongvu Blog",
      url: "https://blog.hlongvu.com",
      image: "https://images.unsplash.com/photo-1519337265831-281ec6cc8514?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e0604c8783c88d26ff2b89c3fc0ac137&auto=format&fit=crop&w=1500&q=80",
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
      title1: "hlongvu",
      fb: %{
        appid: "1200129192192192",
        video: "xxx",
        video: %{
          name: "video_name",
          width: "100",
          height: "200"
        }
      }
    }


    result1 = tag(:meta, content: "hlongvu",  property: "title1")
    result2 = tag(:meta, content: "1200129192192192",  property: "fb:appid")
    result3 = tag(:meta, content: "video_name",  property: "fb:video:name")
    result4 = tag(:meta, content: "100",  property: "fb:video:width")
    result5 = tag(:meta, content: "200",  property: "fb:video:height")


    other_tags = render_tags_other(tags)
    assert other_tags -- [result1, result5,  result3, result4, result2] == []

  end


end
