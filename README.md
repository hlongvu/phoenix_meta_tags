## PhoenixMetaTags

This is a library helps generate meta tags for a website.

### Default Usage

From a struct like this:

```elixir
%{
    title: "Phoenix Title",
    description: "Phoenix Descriptions",
    url: "https://phoenix.meta.tags",
    image: "https://phoenix.meta.tags/logo.png"
}
```

will become:

```html
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

### Advanced Usage
Other key value of tags map will be rendered individualy by key. Nested map will be rendered by *flat-representation* of keys. For example:


```elixir
 map = %{
     title: "Phoenix Title",
     description: "Phoenix Descriptions",
     url: "https://phoenix.meta.tags",
     image: "https://phoenix.meta.tags/logo.png",
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
```

In addition to default tags like above example, the rendered tags will have more:

```html
<meta content="facebook" property="fb:name">
<meta content=100 property="fb:size:width">
<meta content=200 property="fb:size:height">
<meta content=10 property="fb:size:position:x">
<meta content=15 property="fb:size:position:y">

```



Instead of a nested map, you can also use a string-key map, this also delivers the same result:

```elixir
map = %{
      "title": "PhoenixTags",
      "fb:name": "facebook",
      "fb:size:width": 100,
      "fb:size:height": 200,
      "fb:size:position:x": 10,
      "fb:size:position:y": 15
    }

```


### Tag Value Override

In default rendering, the **og:title** tag will get value from **title**. If you re-define **og:title** value, the new value will be override the default **title** value. For example:

```elixir
 map = %{
     title: "Phoenix Title",    
     og: %{
        title: "Override"
        }
 }
```

Will have ouput:

```html
<title>Phoenix Title</title>
<meta content="Phoenix Title" name="title">
<meta content="Override" property="og:title">
```

## Installation

The package can be installed
by adding `phoenix_meta_tags` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_meta_tags, ">= 0.1.3"}
  ]
end
```
In your Web Module add this:

```elixir
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

```elixir
<head>
    <%= render_tags_all(assigns[:meta_tags] || %{})%> # Add this
</head>
```

## Usage

Wherever you want to render meta tags, jut put it before render your view:

```elixir
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

```elixir
@meta  %{
    title: "Phoenix Title",
    description: "Phoenix Descriptions",
    url: "https://phoenix.meta.tags",
    image: "https://phoenix.meta.tags/logo.png"
}

plug :put_meta_tags, @meta

```


### Default value
You can put the default value for meta tags in your config file. This config will be merge with runtime tags before rendering.

```elixir
config :phoenix_meta_tags,
       title: "Phoenix Title Default",
       description: "Phoenix Descriptions Default",
       url: "https://phoenix.meta.tags.default",
       image: "https://phoenix.meta.tags.default/logo.png",
       "og:text": "Hello Open Graph",
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
                  
```

