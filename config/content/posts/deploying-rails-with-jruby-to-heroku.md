---
date: "2012-11-16"
title: Deploying Rails with JRuby to Heroku
summary: Deploying JRuby on Heroku used to require custom build packs. Not any more. This guide will get any JRuby app up and running in no time.
tags:
  - ruby
  - rails
  - jruby
  - heroku
---

# Setup

JRuby offers a number of concurrency advantages over MRI. It can integrate with existing Java libraries and makes use of the rock solid JVM. It can also be deployed to Heroku.

# Step 1: Modify Your Gemfile

```ruby
#ruby=jruby-1.7.4
ruby '1.9.3', engine: 'jruby', engine_version: '1.7.4'

gem 'puma'
gem 'rails', '3.2.9'
gem 'puma'
gem 'jruby-openssl', platforms: :jruby
gem 'activerecord-jdbcpostgresql-adapter', platforms: :jruby
gem 'therubyrhino', platforms: :jruby
```

# Step 2: Modify Your Procfile

```ruby
web: bundle exec rails server puma -p $PORT -e $RACK_ENV
```

# Step 3: Configure Your Application

```bash
heroku create
heroku config:set PATH=bin:/app/vendor/bundle/jruby/1.9/bin:/usr/local/bin:/usr/bin:/bin
heroku config:set GEM_PATH=vendor/bundle/jruby/1.9
```

# Step 4: Deploy

```bash
git push heroku master
```
