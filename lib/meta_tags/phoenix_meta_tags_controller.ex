defmodule PhoenixMetaTags.TagController do
  @moduledoc """
  Documentation for PhoenixMetaTags.
  """

  defmacro __using__(_) do
    quote do
      def put_meta_tags(conn, tags) do
        Plug.Conn.assign(conn, :meta_tags, tags)
      end
    end
  end
end
