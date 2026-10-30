---
date: "2018-08-01"
title: Building a Testing Framework Similar to RSpec in Ruby
summary: A guide to building and understanding a testing frameworks like RSpec
tags:
  - ruby
  - rspec
  - testing
  - gem
  - bundler
---

Testing frameworks are an essential part of building apps or frameworks. What goes into building one? This tutorial explores the steps needed to build such a tool from scratch: [Specifier](http://github.com/ksylvest/specifier). Once everything is setup the following 'spec' can be executed:

```ruby
class Echo
  def say(message)
    message
  end
end

Specifier.specify Echo do
  describe '#say' do
    it 'says "Hello" if you say "Hello"' do
      echo = Echo.new
      expect(echo.say('Hello')).to equal('Hello')
    end
  end
end
```

# Setup

Like other testing frameworks it is packaged as a [gem](http://guides.rubygems.org/what-is-a-gem/). Building a gem is easy using [Bundler](http://bundler.io/) - which configures the core files needed for packaging the library by running the following:

```bash
gem install bundler
bundle gem specifier --bin --test=rspec
cd specifier
```

The above generates a **gemspec**, default **lib** and **spec** files and folders, and a few other configuration files. The **gemspec** needs to be filled in prior to proceeding by removing any TODOs and adding in **slop** as dependencies (more on that later):

**./specifier.gemspec**

```ruby
spec.files = Dir.glob('{exe,lib}/**/*') + %w[README.md Gemfile]
spec.summary = 'A testing framework written for fun.'
spec.description = 'This should probably never be used.'
spec.license     = 'MIT'

# ...

spec.add_dependency 'slop'
spec.add_development_dependency 'bundler'
spec.add_development_dependency 'rake'
spec.add_development_dependency 'rspec'
```

The above also generates a `lib/specifier.rb` file. Anytime a new file is added it needs to be required in `lib/specifier.rb` to be used as part of the gem (`lib/specifier/version.rb` is required by default). The gem can be used by the console (exit and open when changing things):

```bash
bin/console
```

```ruby
Specifier::VERSION # 0.1.0
```

# Matchers and Expectations

A spec is composed of a number of an expectation and matchers. They are used by code like this:

```ruby
expect('today').to equal('tomorrow')
```

For this example `expect` instantiates an expectation and `equal` instantiates a matcher. To get something close to this example these files can be added:

**lib/specifier/matcher/equal.rb**

```ruby
module Specifier
  module Matcher
    class Equal
      def initialize(value)
        @value = value
      end

      def match?(expected)
        @expected = expected
        expected.eql?(@value)
      end

      def message
        "expected #{@expected.inspect} got #{@value.inspect}"
      end
    end
  end
end
```

**lib/specifier/expectation.rb**

```ruby
module Specifier
  class Expectation
    def initialize(value)
      @value = value
    end

    def to(matcher)
      raise(matcher.message) unless matcher.match?(@value)
    end
  end
end
```

The above classes can be used together like this:

```ruby
Specifier::Expectation.new('today').to(Specifier::Matcher::Equal.new('tomorrow'))
```

To get closer to the desired spec syntax the concept of a 'world' that specs are executed within needs to be introduced:

**lib/specifier/world.rb**

```ruby
module Specifier
  class World
    def expect(value)
      Expectation.new(value)
    end

    def equal(value)
      Matcher::Equal.new(value)
    end
  end
end
```

Now the following works:

```ruby
world = Specifier::World.new
world.expect('today').to world.equal('tomorrow')
```

# Contexts and Examples

A spec is also composed of a combination of contexts and examples. They are used by code like this:

```ruby
describe 'a sample context' do
  it 'a sample example' do
    expect('today').to equal('tomorrow')
  end
end
```

These are implemented using a few classes:

**lib/specifier/example.rb**

```ruby
module Specifier
  class Example
    Result = Struct.new(:status, :message)

    def initialize(description, &block)
      @description = description
      @block = block
    end

    def run(world)
      world.instance_eval(&@block)
      return Result.new(:pass)
    rescue => message
      return Result.new(:fail, message)
    end

  end
end
```

**lib/specifier/context.rb**

```ruby
module Specifier
  class Context
    def self.setup(description, parent = nil, &block)
      context = new(description, parent, &block)
      parent.children << context if parent
      context.instance_eval(&block)
      context
    end

    def initialize(description, parent = nil, &block)
      @description = description
      @parent = parent
      @block = block
      @children = []
      @examples = []
      @definitions = []
    end

    def describe(description, &block)
      self.class.setup(description, self, &block)
    end

    def it(description, &block)
      @examples << Example.new(description, &block)
    end

    def run
      puts description
      @examples.each do |example|
        world = Specifier::World.new
        result = example.run(world)
        puts "#{example.description} #{result.inspect}"
      end
      @children.each(&:run)
    end
  end
end
```

At this point the following syntax works:

```ruby
context = Specifier::Context.new('root')
context.describe 'a sample context' do
  it 'a sample spec' do
    expect('today').to equal('tomorrow')
  end
end
context.run
```

# Formatters and Loggers

Specs are aided by using a variety of formatters and loggers. Loggers are different streams data can be sent to (usually `STDOUT`). Formatters are how to structure the results (i.e. stars and dots, pass and fail, etc). For specifier a simple logger to `STDOUT` and formatter that displays `[PASS]` or `[FAIL]` used:

**lib/specifier/logger.rb**

```ruby
module Specifier
  class Logger
    def initialize(stream = STDOUT)
      @stream = stream
    end

    def log(message = nil)
      @stream.puts message
    end
  end
end
```

**lib/specifier/formatter.rb**

```ruby
module Specifier
  class Formatter
    def initialize(logger)
      @logger = logger
    end

    def record(example, result)
      message =
        case result.status
        when :pass then "[PASS] #{example.description}"
        when :fail then "[FAIL] #{example.description}"
        end

      @logger.log(message)
    end

    def context(context)
      @logger.log(context.description)
      yield
    end
  end
end
```

The logger and formatter can be setup as singletons on our base module and some boiler plate configuration:

**lib/specifier.rb**

```ruby
module Specifier
  def self.config
    @config ||= Config.new
  end

  def self.logger
    @logger ||= Logger.new
  end

  def self.formatter
    @formatter ||= Formatter.new(logger)
  end

  def self.contexts
    @contexts ||= []
  end

  def self.specify(scope, &block)
    contexts << Context.setup(scope, &block)
  end

  def self.run
    contexts.each(&:run)
  end
end
```

Then the example can be modified to use the formatter / logger:

**lib/specifier/context.rb**

```ruby
module Specifier
  class Context
    # ...
    def run
      Specifier.formatter.context(self) do
        @examples.each do |example|
          world = Specifier::World.new
          result = example.run(world)
          Specifier.formatter.record(example, result)
        end
        @children.each(&:run)
      end
    end
  end
end
```

Now this example runs:

```ruby
Specifier.specify 'a sample context' do
  it 'ensures today is tomorrow' do
    expect('today').to equal('tomorrow')
  end
end
Specifier.run
```

# CLI and Runner

Every useful testing framework offers a CLI, and specifier is no different. This is where slop is useful for handling our CLI interface:

**exe/specifier**

```ruby
#!/usr/bin/env ruby

require 'specifier'

cli = Specifier::CLI.new
cli.parse
```

**lib/specifier/runner.rb**

```ruby
module Specifier
  class Runner
    def initialize(paths:)
      @paths = paths
    end

    def run
      @paths.each do |path|
        load path
      end

      Specifier.run
    end
  end
end
```

**lib/specifier/cli.rb**

```ruby
module Specifier
  class CLI

    def parse(items = ARGV)
      config = Slop.parse(items)
      run(config)
    end

  private

    def run(options)
      paths = Set.new
      options.arguments.each do |argument|
        Find.find(argument) do |path|
          paths << path if path.match?(/\A(.*).rb\Z/)
        end
      end
      Runner.new(paths: paths).run
    end

  end
end
```

That's it! Specs anywhere can now be run using the gem CLI once installed:

```bash
rake install
```

```bash
specifier ./echo_spec.rb
```

To find a more detailed example of specifier run `gem install specifier` or try [Specifier](http://github.com/ksylvest/specifier).
