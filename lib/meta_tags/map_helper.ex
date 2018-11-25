defmodule PhoenixMetaTags.MapHelper do
  def flatMap(map) do
    map
    |> Enum.map( fn {k,v} -> flatMapChild("", k,v) end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn x, acc -> Map.merge(acc, x) end)
  end

  defp flatMapChild(prefix, key, value) when is_map(value) do
    p = prefix_for(prefix, key)
    value
    |> Enum.map(fn {k,v} -> flatMapChild(p, k, v) end)
    |> List.flatten()
  end

  defp flatMapChild(prefix, key, value) do
    p = prefix_for(prefix, key)
    %{p => value}
  end

  defp prefix_for(prefix, key) do
    if (prefix == ""), do: Atom.to_string(key), else: prefix <> ":" <> Atom.to_string(key)
  end
end
