---
date: "2013-07-23"
title: Packaging a jQuery Plugin with Bower
summary: Bower is a great package manager for JavaScript or CSS Files. It can be easily used to package a jQuery plugin.
tags:
  - bower
  - jquery
  - plugin
---

The guide shows (**whoever**) how to pacakge a plugin (**whatever**) for [Bower](https://bower.io/). It assumes that a [jQuery Plugin](https://plugins.jquery.com/) exists and has been setup for jQuery Plugins (for a guide to setting up a plugin see: [A Rubyist Guide to Creating jQuery Plugins](/posts/2013-07-14/a-rubyist-guide-to-creating-jquery-plugins)).

# Configuration

Bower is a package manger for CSS and JS (front end assets). It is extremly simple to integrate with an existing plugin. First install NPM and Bower:

```bash
brew install npm
npm install -g bower
```

Next add the following files to the project:

**bower.json**:

```json
{
  "name": "gridly",
  "version": "1.0.0",
  "main": ["./javascripts/jquery.whatever.js", "./stylesheets/jquery.whatever.css"],
  "ignore": [
    "README*",
    "LICENSE*",
    "**/*.sass",
    "**/*.coffee",
    "**/sample.*",
    "**/rainbow.js",
    "**/rainbow.css",
    "**/jquery.js",
    "**/jquery.css",
    "samples",
    "spec",
    "bourbon",
    "neat",
    "packages",
    "images",
    "Cakefile*",
    "Rakefile*",
    "Gemfile*",
    ".git*",
    ".travis*",
    "*bower.json",
    "*jquery.json",
    "index*"
  ],
  "dependencies": { "jquery": "latest" }
}
```

# Publishing

```bash
git add .
git commit -m "	bower"
git push origin master
bower register gridly git://github.com/whoever/jquery-whatever.git
```
