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
      fb: %{appid: "1200129192192192"}
    }


    result1 = tag(:meta, content: "https://blog.otherurl.com",  property: "other_url")
    result2 = tag(:meta, content: "1200129192192192",  property: "fb:appid")


    other_tags = render_tags_other(tags)
    assert other_tags == [result2, result1]

  end



end
