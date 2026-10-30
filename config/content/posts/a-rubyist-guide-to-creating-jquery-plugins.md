---
date: "2013-07-14"
title: A Rubyist Guide to Creating jQuery Plugins
summary: Learn how to create a jQuery plugin using Haml, Sass, and CoffeeScript. Then deploy the plugin to the jQuery plugin repository.
tags:
  - jquery
  - plugin
  - coffeescript
---

Ruby programmers are use to packaging up libraries into gems, but what about _js_ and _css_? One option for these is to package them as jQuery plugins. The following guide shows you (**whoever**) how to make a plugin (**whatever**).

# Dependencies

This guide relies on having a few dependencies:

- [Git](http://git-scm.com/)
- [Bundler](http://bundler.io/)
- [Cake](https://coffeescript.org/#cake)

If installing these seems difficult try: [https://github.com/ksylvest/setup](https://github.com/ksylvest/setup)

# Structure

To start create a new directory for the plugin (named jquery-**whatever**) and add these files:

**Gemfile**:

```ruby
# Gemfile
source 'https://rubygems.org'

gem 'haml'
gem 'sass'
gem 'bourbon'
```

**Cakefile**:

```coffeescript
PROJECT = "jquery.whatever"

{spawn, exec} = require "child_process"

command = (name, args...) ->
  proc = spawn name, args

  proc.stderr.on "data", (buffer) ->
    console.log buffer.toString()

  proc.stdout.on "data", (buffer) ->
    console.log buffer.toString()

  proc.on "exit", (status) -> process.exit(1) if status != 0

task "watch", "SASS and CoffeeScript", (options) ->
  command "sass", "--watch", "stylesheets:stylesheets"
  command "coffee", "-wc", "javascripts"

task "compile", "HAML", (opions) ->
  command "haml", "index.haml", "index.html"

task "package", "Package CSS and JS", (options) ->
  command "zip", "packages/#{PROJECT}.zip", "javascripts/#{PROJECT}.js", "stylesheets/#{PROJECT}.css"
  command "tar", "-cf", "packages/#{PROJECT}.tar", "javascripts/#{PROJECT}.js", "stylesheets/#{PROJECT}.css"
```

**whatever.jquery.json**

```json
{
  "name": "whatever",
  "title": "jQuery Whatever",
  "description": "Whatever is a jQuery plugin for demonstration purposes only.",
  "keywords": ["animation"],
  "version": "1.0.0",
  "author": {
    "name": "Whoever",
    "email": "info@whoever.com",
    "url": "http://whoever.com/"
  },
  "licenses": [
    {
      "type": "MIT",
      "url": "https://github.com/whoever/jquery-whatever/LICENSE"
    }
  ],
  "bugs": "https://github.com/whoever/jquery-whatever/issues",
  "docs": "https://whoever.github.com/jquery-whatever",
  "homepage": "https://whoever.github.com/jquery-whatever",
  "download": "https://whoever.github.com/jquery-whatever",
  "dependencies": {
    "jquery": ">1.5"
  }
}
```

**README.md**:

```text
# jQuery Whatever

Whatever is a jQuery plugin for demonstration purposes only.

## Installation

To install copy the *javascripts* and *stylesheets* directories into your project and add the following snippet to the header:

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.js" type="text/javascript"></script>
    <script src="javascripts/jquery.whatever.js" type="text/javascript"></script>
    <link href="stylesheets/jquery.whatever.css" rel="stylesheet" type="text/css" />

## Copyright

Copyright (c) Whoever. See LICENSE for details.
```

**LICENSE**:

```text
Copyright (c) Whoever

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

**index.haml**

```haml
!!! 5
%html
  %head
    %meta{ charset: "UTF-8" }
      %title jQuery Whatever
      %link{ href:"stylesheets/jquery.whatever.css", rel: "stylesheet", type: "text/javascript" }
      %script{ src:"https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.js", type: "text/javascript" }
      %script{ src:"javascripts/jquery.whatever.js", type: "text/javascript" }
  %body
    .content
      %h1 jQuery Whatever
      %p Whatever is a jQuery plugin for demonstration purposes only.
      %h2 Example
      %section.example
      ...
      %section.download
        %a.zip{ href: "packages/jquery.whatever.zip" } ZIP
        %a.tar{ href: "packages/jquery.whatever.tar" } TAR
      %p Copyright (c) Whoever.
```

Now create a few directories: **packages**, **javascripts**, **stylesheets**

# Setup

Next run the following from within the directory:

    bundle
    bundle exec bourbon install
    cake compile

And then start watching for changes in your **javascripts** and **stylsheets** by running:

    cake watch

# Development

It is time to start creating the core files. Typically small jQuery plugins will have a single js and css file. For example: **jquery.whatever.css** and **jquery.whatever.js**. For this plugin these files will be generated from [Sass](http://sass-lang.com/) and [CoffeeScript](http://coffeescript.org/). Try the following example:

**stylesheets/jquery.whatever.sass**

```sass
/*
 * jQuery Whatever
 * Copyright 2013 Whoever
 * 1.0.0
 */

@import bourbon/bourbon

$namespace: "whatever"
$fast: 0.2s

.#{$namespace}
  +transition(color $fast ease-in-out)

  &.nifty
    color: #ABC

  &.funky
    color: #DEF
```

**javascripts/jquery.whatever.coffee**

```coffeescript
###
jQuery Whatever
Copyright 2013 Whoever
1.0.0
###

"use strict"

$ = jQuery

class Whatever

  @settings:
    style: 'nifty'

  @whatever: ($el, settings = {}) ->
    data = $el.data('_lighter')
    unless data
      data = new Whatever($el, settings)
      $el.data('_whatever', data)
    return data

  constructor: ($el, settings = {}) ->
    @$el = $el
    @settings = $.extend {}, Whatever.setting, settings
    @$el.addClass(@settings.style)

  show: =>
    @$el.show()

  hide: =>
    @$el.hide()

$.fn.extend
  whatever: (option = {}) ->
    @each ->
      $this = $(@)

      options = $.extend {}, $.fn.whatever.defaults, typeof option is "object" and option
      action = if typeof option is "string" then option else option.action

      object = Whatever.whatever($this, options)
      object[action]() if action?

$(document).on "click", "[data-whatever]", (event) ->
  event.preventDefault()
  event.stopPropagation()

  $(this).whatever()
```

The **.scss** and **.coffee** files are automatically compiled by the cake script. The code we have thus far will construct a **Whatever** when clicking on any element with a **data-whatever** attribute. In addition, the plugin supports the following API for developers:

```javascript
$(".random").whatever({ style: "funky" });
$(".random").whatever("show");
$(".random").whatever("hide");
```

# Publishing

Once the plugin is ready to be released it can be published to [http://plugins.jquery.com/](http://plugins.jquery.com/). This requires deploying the plugin to [GitHub](https://github.com/) then setting up a post deploy hook. The following uses the GitHub command line tool [hub](https://github.com/github/hub):

```bash
git init
hub create jquery-whatever
hub browse
```

From your project page go to the **settings** section then open **hooks** activate **jQuery Plugins**. Then it is time to deploy:

```
cake package
git add .
git commit -m "packaging"
git tag -a "v1.0.0" -m .
git push origin master
git push origin master:gh-pages
git push origin --tags
```

If everything works (and your plugin name has not already been registered) the plugin will be hosted **http://plugins.jquery.com/whatever/**. The links to the code, documentation, and demo should all be active.

# Examples

For examples of plugins created in this style see:

- [http://ksylvest.github.io/jquery-gridly/](http://ksylvest.github.io/jquery-gridly/)
- [http://ksylvest.github.io/jquery-lighter/](http://ksylvest.github.io/jquery-lighter/)
- [http://ksylvest.github.io/jquery-growl/](http://ksylvest.github.io/jquery-growl/)
- [http://ksylvest.github.io/jquery-spin/](http://ksylvest.github.io/jquery-spin/)
