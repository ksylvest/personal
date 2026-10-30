---
date: "2014-05-28"
title: Rails Concerns for URL and Path Helpers
summary: Concerns offer a reusable way of sharing common code. This can be used to extract URL helpers.
tags:
  - ruby
  - rails
  - concerns
---

Accessing a URL or path directly from a model can help to remove repetition in code. Consider the following:

```ruby
# config/routes.rb
get 'posts/:segment/:slug', to: 'posts#show', as: :post
```

```ruby
# app/views/posts/_preview.html.haml
- @posts.each do |post|
  - # <a href='/posts/2014-05-27/an-example-post'>An Example Post</a>
  = link_to post.title, posts_path(post, segment: post.segment, slug: post.slug)
```

While the code to generate the URL is not overly complex, once it is repeated throughout a number of views and controllers it can lead to maintainability problems. Changing the URL for SEO optimization requires changing multiple locations. The most robust solution for this problem is to use the decorator pattern through a gem like [Draper](https://github.com/drapergem/draper). However, an alternative (or supplementary) solution is to expose accessors directly on the model:

```ruby
# app/models/concerns/links.rb

module Links
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: "Rails.application.routes"
    alias :h :url_helpers
  end

  def url
    h.send :"#{self.route}_url", parameterize
  end

  def path
    h.send :"#{self.route}_path", parameterize
  end

  def route
    self.class.name.parameterize
  end

  def parameterize
    self.id
  end

end
```

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  include Links

  # Configuration:
  def parameterize
    { segment: self.segment, slug: self.slug }
  end
end
```

This snippet enables a developer to refactor the view to call `post.url` or `post.path`. As a last step to ensure that the URL works outside of views add a default host in an initializer:

```ruby
# config/initializers/hosts.rb
Rails.application.routes.default_url_options[:host]= 'https://ksylvest.com'
```
