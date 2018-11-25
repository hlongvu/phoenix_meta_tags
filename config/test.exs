use Mix.Config

config :phoenix_meta_tags,
       title: "config_title",
       fb: %{
         appid: "1200129192192192",
         video: %{
           name: "video_name",
           width: "100",
           height: "200"
         }
       },
       "fb:video": "abc"