---
layout: post
title:  "Jekyll setup"
date:   2018-07-31
categories: jekyll 
---

I'm using Markdown to write my journal / documentation, and publishing it to the web using [Jekyll](https://jekyllrb.com/). In order to get Jekyll to work as I want it I've had to make some customisations. Deployment can also be a bit fiddly. So I'm documenting that as well. Meta, yep.

## Terminal commands

Things I need to type repeatedly:

Go to my Jekyll directory: `cd /Users/andrew/Documents/Processing/website`

Serve to a temp local directory for testing: `bundle exec jekyll serve` (This seems to ignore the `site.url`  and `site.baseurl` variables...)

Build to the staging directory: `jekyll build --destination ../website-staging/`


## Uploading

Use the sync function in Cyberduck to sync my staging folder with one on my web host over SSH

Set it to upload only, otherwise it gets confused about modification dates (perhaps?)

I think there should be a way to do this using `rsync` over SSH, without leaving the command line. [Here are some good instructions](
https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps), but I can't get it to work right now. 


## Fixing URLs for deploying to a different directory structure:

### Understanding the variables:

From [https://jekyllrb.com/docs/variables/](https://jekyllrb.com/docs/variables/)

> page.url
The URL of the Post without the domain, but with a leading slash, e.g.  /2008/12/14/my-post.html

That leading slash causes problems if you use the post URL as a relative URL - as it starts at the root of the domain

### Override core templates:

The minima theme uses post.url with a relative URL filter in the [liquid markup language](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers). I need to override this with some custom templates:


### Find the gem to modify

From https://jekyllrb.com/docs/themes/


```
open $(bundle show minima)
```

Copy the files you want to modify to your sitebin, following the same structure

```ruby{% raw %} 
<a class="post-link" href="{{ post.url | relative_url }}">
  {{ post.title | escape }}
</a>
{% endraw %} ```


I need to change this to:

```ruby{% raw %} 
<a class="post-link" href="{{ site.url }}{{ site.baseurl }}{{ post.url }}">
  {{ post.title | escape }}
</a>
{% endraw %} ```


## Adding categories/tags

In Wordpress, this can be done dynamically. It's a little more fiddly in Jekyll, if you don't want to use plugins.

I followed these instructions:
https://www.chrisanthropic.com/blog/2014/jekyll-themed-category-pages-without-plugins/
https://www.mikeapted.com/jekyll/2015/12/30/category-and-tag-archives-in-jekyll-no-plugins/

The steps broken out:

* Create a `category.html` page in a (new, if need be) `/_layouts` directory:

``` ruby  {% raw %} 
---
layout: default
---

{% for post in site.categories[page.category]  %}
    <h3><a href="{{ post.url | relative_url }}">
      {{ post.title }}
    </a></h3>
     <p>{{ post.excerpt }} </p>
{% endfor %}
{% endraw %}```

* Create templates for each category inside a `/category` directory. For example, for the Plotter category:

``` ruby
---
layout: category
title: Plotter
category: plotter
---
```

* Add a category to the frontmatter of each Jekyll post:

``` ruby
---
layout: post
title:  "Getting started with the pen plotter"
date:   2018-07-31
categories: plotter
---
```


## Formating and escaping code

Use the {% raw %} ```{% endraw %} delimiters around code blocks. If you're writing liquid syntax inside those code blocks you can with the `raw` and `endraw` tags.

Apply appropriate syntax highlighting with `ruby` or `processing` tags.


## Linking between pages internally


This is trickier than it should be. Here's the format that works:


``` ruby  {% raw %}
An [internal link({{ site.baseurl }}{% post_url 2018-07-23-title %})
{% endraw %}```

i.e: 
 - Take the filename of the page you want to link to
 - Knock off the `.md` extension
 - Enclose it in the `post_url` liquid markup tag
 - Prepend it with the `site.baseurl` variable
 - Wrap that in (brackets)
 - Wrap the link text in [square brackets]



