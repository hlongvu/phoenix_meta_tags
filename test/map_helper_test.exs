defmodule MapHelerTest do
  use ExUnit.Case
  alias PhoenixMetaTags.MapHelper
  use Phoenix.HTML

  test "test map helper" do
    map = %{
      title: "PhoenixTags",
      fb: %{
        name: "facebook",
        size: %{
          width: 100,
          height: 200,
          position: %{
            x: 10,
            y: 15
          }
        }
      }
    }

    new_map = MapHelper.flatMap(map)

    expected_map = %{
      "title" => "PhoenixTags",
      "fb:name" => "facebook",
      "fb:size:width" => 100,
      "fb:size:height" => 200,
      "fb:size:position:x" => 10,
      "fb:size:position:y" => 15
    }

    assert Map.equal?(new_map, expected_map)
  end
end
