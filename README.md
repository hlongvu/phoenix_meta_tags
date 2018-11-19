## PhoenixMetaTags

This is a library helps generate meta tags for a website.
From a struct like this:

```
%{
    title: "Phoenix Title",
    description: "Phoenix Descriptions",
    url: "https://phoenix.meta.tags",
    image: "https://phoenix.meta.tags/logo.png"
}
```
will become:

```
# Default tags
<title>Phoenix Title</title>
<meta content="Phoenix Title" name="title">
<meta content="Phoenix Descriptions" name="description">

#Open Graph tags
<meta content="website" property="og:type">
<meta content="https://phoenix.meta.tags" property="og:url">
<meta content="Phoenix Title" property="og:title">
<meta content="Phoenix Descriptions" property="og:description">
<meta content="https://phoenix.meta.tags/logo.png" property="og:image">

#Twitter tags
<meta content="summary_large_image" property="twitter:card">
<meta content="https://phoenix.meta.tags" property="twitter:url">
<meta content="Phoenix Title" property="twitter:title">
<meta content="Phoenix Descriptions" property="twitter:description">
<meta content="https://phoenix.meta.tags/logo.png" property="twitter:image">

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `phoenix_meta_tags` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_meta_tags, "~> 0.1.0"}
  ]
end
```
In your Web Module add this:

```
 def view do
    quote do
		...
   		use PhoenixMetaTags.TagView # Add this
    end
 end
 
  def controller do
    quote do
	    ...
	    use PhoenixMetaTags.TagController # Add this 
    end
  end
```
Also put this render function inside your **\<head\>** tag of app.html.eex:

```
 <head>
    <%= render_tags_all(assigns[:meta_tags] || %{})%>
</head>
```
## Usage

Wherever you want to render meta tags, jut put it before render your view:

```
conn
|> put_meta_tags(
     %{
       title: "Phoenix Title",
       description: "Phoenix Descriptions",
       url: "https://phoenix.meta.tags",
       image: "https://phoenix.meta.tags/logo.png"
     })
|>render("index.html")
```

Or, use it as a plug:

```
  @meta  %{
    title: "Phoenix Title",
    description: "Phoenix Descriptions",
    url: "https://phoenix.meta.tags",
    image: "https://phoenix.meta.tags/logo.png"
  }

  plug :put_meta_tags, @meta

```


### Default value
You can put the default value for meta tags in your config file:

```
config :phoenix_meta_tags,
       title: "Phoenix Title Default",
       description: "Phoenix Descriptions Default",
       url: "https://phoenix.meta.tags.default",
       image: "https://phoenix.meta.tags.default/logo.png"       
```
If a controller has no meta tags, this default value will be used.

