---
date: "2012-03-09"
title: Faster Testing in Rails with Guard for Zeus, RSpec, and Cucumber
summary: Two awesome tools for speeding up testing are Zeus and Guard. Setting them up allows for automatic execution of tests while coding.
tags:
  - zeus
  - guard
  - rspec
  - ruby
  - rails
---

Two amazing tools that focus on improving how tests are run rather than written in Ruby on Rails are [Zeus](https://github.com/burke/zeus) and [Guard](https://github.com/guard/guard). So what are they?

# Zeus

Zeus will preload a Ruby on Rails application so that you don't have to whenever running rake, spec, or server commands.

# Guard

Guard monitors the file system and executes tasks whenever files are change.

# Integration

The challenge then becomes setting up Zeus and Guard to work together:

## Step 1. Setup Your Gems

Follow this example Gemfile configured to work with growl, guard, rspec, cucumber and capybara:

```ruby
group :development do
  gem "growl"
  gem "guard"
  gem "guard-bundler"
  gem "guard-cucumber"
  gem "guard-rspec"
  gem "guard-zeus"
  gem "rb-inotify", require: false
  gem "rb-fsevent", require: false
  gem "rb-fchange", require: false
end

group :test do
  gem "capybara"
  gem "capybara-webkit"
  gem "rspec-rails"
  gem "cucumber-rails"
end
```

## Step 2. Setup Your Guards

Follow this example Guardfile configured for cucumber and rspec:

```ruby
guard "bundler" do
  watch("Gemfile")
end

guard "cucumber", command_prefix: "zeus", bundler: false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$}) { "features" }
  watch(%r{^features/step.+/.+$})  { "features" }
end

guard "rspec", zeus: true, bundler: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch("spec/spec_helper.rb")  { "spec" }

  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.slim|\.haml)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch("config/routes.rb")                           { "spec/routing" }
  watch("app/controllers/application_controller.rb")  { "spec/controllers" }

  watch(%r{^app/views/(.+)/.*\.(erb|slim|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }
end
```

## Step 3. Install Growl

[Growl Notify](http://growl.info/downloads)

## Step 4: Install Zeus

```bash
gem install zeus
```

## Step 5. Start Zeus and Guard

```bash
zeus start
bundle exec guard
```
