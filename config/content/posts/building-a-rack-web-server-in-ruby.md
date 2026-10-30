---
date: "2016-10-04"
title: Building a Rack Web Server in Ruby
summary: Managing sockets, handling HTTP parsing and generation, and integrating with Rack to build a simple web server from scratch.
tags:
  - ruby
  - rails
  - rack
  - sockets
---

Every request that is sent to a [Rails](http://rubyonrails.org/) or [Sinatra](http://www.sinatrarb.com/) application goes through [Rack](http://rack.github.io/). Rack is an interface for structuring web applications using Ruby. Rack web servers (i.e. [Puma](http://puma.io/), [Passenger](https://www.phusionpassenger.com/), etc) handle sockets (links between programs running on a network), the semantics of the HTTP protocol, thread or process management, and of course the Rack interface. This article explores building a simple Rack web server entirely in Ruby.

# Setting up a Library as a Gem

The sample web server in this article is named **rhino** - and like other Ruby libraries it is packaged as a [gem](http://guides.rubygems.org/what-is-a-gem/). Building a gem is easy using [Bundler](http://bundler.io/) - which configures the core files needed for packaging the library by running the following:

```
gem install bundler
bundle gem rhino --bin --test=rspec
cd rhino
```

The above generates a **gemspec**, default **lib** and **spec** files and folders, and a few other configuration files. The **gemspec** needs to be filled in prior to proceeding by removing any TODOs and adding in **slop** and **rack** as dependencies (more on them later):

**./rhino.gemspec**

```ruby
spec.summary     = "A web server written for fun."
spec.description = "This should probably never be used."
spec.license     = "MIT"

# ...

spec.add_dependency "slop"
spec.add_dependency "rack"
spec.add_development_dependency "bundler"
spec.add_development_dependency "rake"
spec.add_development_dependency "rspec"
```

# Getting Started with Logging

Logging is going to be a core component of the library. Logging happens when requests are received, when responses are delivered, and when interacting with the command line interface. Since many components rely on logging **rhino** abstracts away the standard streams into a testable interface:

**lib/rhino.rb**

```ruby
require "rhino/logger"
require "rhino/version"

module Rhino
  def self.logger
    @logger ||= Rhino::Logger.new
  end
end
```

**lib/rhino/logger.rb**

```ruby
module Rhino
  class Logger
    def initialize(stream = STDOUT)
      @stream = stream
    end

    def log(message)
      @stream.puts message
    end
  end
end
```

**spec/rhino/logger_spec.rb**

```ruby
require "spec_helper"

describe Rhino::Logger do

  let(:stream) { double(:stream) }

  describe "#log" do
    it "proxies to stream" do
      logger = Rhino::Logger.new(stream)
      expect(stream).to receive(:puts).with("Hello!")
      logger.log("Hello!")
    end
  end

end
```

Once these changes are made the library can be tested by running:

```bash
bundle exec rspec spec
```

The fundamentals of the above provide the building blocks for the next step: the CLI.

# Exploring a Command Line Interface in Ruby

The command line interface (CLI) for a Rack web framework has the responsibility of parsing command line arguments **ARGV** and **ARGC** (**ARGV.length**) and launching the server or printing help information using the supplied arguments. The generated gem contains a executable that is located under **exe/rhino** or **bin/rhino**:

```ruby
#!/usr/bin/env ruby

require "rhino"
```

The CLI can be tested by running:

```bash
bundle exec rhino
```

If everything goes well nothing is printed when the above is run. Since the CLI is going to contain a large portion of code it can be abstracted into a class. The only change for **exe/rhino** or **bin/rhino** is running the aforementioned class:

```ruby
#!/usr/bin/env ruby

require "rhino"

cli = Rhino::CLI.new
cli.parse
```

Testing the CLI again generates an error referencing the uninitialized constant:

```bash
bundle exec rhino
uninitialized constant Rhino::CLI
```

The parsing of command line arguments in **rhino** is handled by a library named [Slop](http://www.rubydoc.info/gems/slop/). The executable allows passing in a **--version** or **--help** flag that cause the program to return after logging the requested information. The CLI can also be configured by passing a **--port**, **--bind**, **--backlog** and **--reuseaddr** with default values for all respective options and an optional path to a rackup file (more on these later). If neither **--help** or **--version** are specified the CLI construct a new launcher class that handles the main execution.

**lib/rhino.rb**

```ruby
require "rhino/cli"
require "rhino/logger"
require "rhino/version"

module Rhino
  def self.logger
    @logger ||= Rhino::Logger.new
  end
end
```

**lib/rhino/cli.rb**

```ruby
require "slop"

module Rhino
  class CLI
    BANNER = "usage: rhino [options] [./config.ru]".freeze

    def parse(items = ARGV)
      config = Slop.parse(items) do |options|
        options.banner = BANNER

        options.on "-h", "--help", 'help' do
          return help(options)
        end

        options.on "-v", "--version", 'version' do
          return version
        end

        options.string "-b", "--bind", 'bind (default: 0.0.0.0)', default: "0.0.0.0"
        options.integer "-p", "--port", 'port (default: 5000)', default: 5000
        options.integer "--backlog", 'backlog (default: 64)', default: 64
        options.boolean "--reuseaddr", 'reuseaddr (default: true)', default: true
      end

      run(config)
    end

  private

    def help(options)
      Rhino.logger.log("#{options}")
    end

    def version
      Rhino.logger.log(VERSION)
    end

    def run(options)
      config, = options.arguments
      Launcher.new(options[:port], options[:bind], options[:reuseaddr], options[:backlog], config || "./config.ru").run
    end

  end
end
```

**spec/rhino/cli_spec.rb**

```ruby
require 'spec_helper'

describe Rhino::CLI do
  let(:cli) { Rhino::CLI.new() }
  let(:launcher) { double(:launcher) }

  describe "#parse" do
    %w(-v --version).each do |option|
      it "supports '#{option}' option" do
        expect(Rhino.logger).to receive(:log).with Rhino::VERSION
        cli.parse([option])
      end
    end

    %w(-h --help).each do |option|
      it "supports '#{option}'" do
        expect(Rhino.logger).to receive(:log).with <<~DEBUG
        usage: rhino [options] [./config.ru]
            -h, --help     help
            -v, --version  version
            -b, --bind     bind (default: 0.0.0.0)
            -p, --port     port (default: 5000)
            --backlog      backlog (default: 64)
            --reuseaddr    reuseaddr (default: true)
        DEBUG
        cli.parse([option])
      end
    end

    it "builds a launcher and executes run" do
      expect(Rhino::Launcher).to receive(:new).with(4000, "0.0.0.0", true, 16, "./config.ru") { launcher }
      expect(launcher).to receive(:run)
      cli.parse(["--port", "4000", "--bind", "0.0.0.0", "--backlog", "16"])
    end
  end

end
```

Once these changes are made the library can be tested by running:

```bash
bundle exec rspec spec
```

The launcher spec fails (since the class hasn't been defined yet). The CLI can also be tested from the command line by running:

```bash
bundle exec rhino --version
0.1.0
```

```bash
bundle exec rhino --help
usage: rhino [options] [./config.ru]
    -h, --help     help
    -v, --version  version
    -b, --bind     bind (default: 0.0.0.0)
    -p, --port     port (default: 5000)
    --backlog      backlog (default: 64)
    --reuseaddr    reuseaddr (default: true)
```

```bash
bundle exec rhino
uninitialized constant Rhino::CLI::Launcher
```

This covers the general configuration for building a simple CLI gem. Next up is meat and potatoes.

# Using Sockets in Ruby

Sockets share a lot of similarities with files (especially on UNIX). They can be read from or written to. They can communicate within a process, between separate processes, or even between different computers over a network. Sockets are managed by the system calls **socket()**, **bind()**, **listen()**, **select()**, **accept()** and **close()** (all conveniently wrapped by the Ruby socket and IO libraries).

Open a new `irb` instance and run the following snippet:

```ruby
require 'socket'

begin
  socket = Socket.new(:INET, :STREAM)
  socket.bind(Addrinfo.tcp('0.0.0.0', 8000))
  socket.listen(8)
  loop do
    listening, = IO.select([socket])
    io, = listening
    connection, addrinfo = io.accept
    echo = connection.gets
    connection.puts echo
    connection.close
  end
ensure
  socket.close
end
```

Then in a new terminal run:

```bash
nc localhost 8000
Testing
```

Surprisingly this snippet covers everything needed to handle the networking communication for **rhino**. The code makes more sense when stepped through section by section.

```ruby
socket = Socket.new(:INET, :STREAM)
```

The **socket()** system call is wrapped by **Socket.new**. It returns a file descriptor. When creating we specify **INET** (a shortcut specifying it is an IP socket) and **STREAM** (able to handle TCP - configures IPv4, IPv6, etc). The socket

```ruby
socket.bind(Addrinfo.tcp('0.0.0.0', 8000))
```

The **bind()** system call assigns our the file descriptor for a socket to an address structure (localhost:8000).

```ruby
socket.listen(8)
```

The **listen()** system call is a signal that takes a socket file descriptor and indicates a willingness to receive connections. It takes a backlog - a limit on the number of queued pending connections the socket allows.

```ruby
loop do
  listening, = IO.select([socket])
  io, = listening
  # ...
end
```

The **select()** system call takes multiple file descriptors and waits until one becomes "ready". **IO.select** can be supplied with three different arrays - read, write and error - that each yield as "ready" if readable, writable or exceptions respectively. Since the sample web server only uses a single socket and accepts when a request is ready to read the other options are ignored. The return value of **IO.select** is an array of arrays containing the IO objects (hence the rather peculiar syntax).

```ruby
connection, addrinfo = io.accept
echo = connection.gets
connection.puts echo
```

The **accept()** system call dequeues a pending connection request from a socket and returns the file descriptor referring to a new socket that can be used to communicate (the original socket is unaffected). At this point the connection is established and the socket can be communicated with using the same IO interface as exposed to file (in the example a line is received from the connection then printed back to the connection).

```ruby
connection.close
# ...
socket.close
```

The **close()** system call closes a file descriptor. It is called in the sample on any socket constructed by **accept()** and the socket constructed by **socket()**.

# A Crash Course on HTTP and Rack

The HTTP protocol is an application level protocol for communicating over a TCP socket that involves request / response pairs. An HTTP request is made up of a **request line** (containing a **method**, **URI**, and **version**), a number of **header lines** (key / value pairs), and an optional **message body**. An HTTP response is made up of a **status line** (containing a **version**, **status**, and **description**), a number of **header lines** (key / value pairs), and an optional **message body**. Both the request and response are delineated by a **CRLF** ("\r\n"). For example:

A client sends an HTTP request:

```text
POST /search HTTP/1.1
Content-Type: text/html
Content-Length: 8

query=hi
```

Then a server sends a corresponding HTTP response:

```text
HTTP/1.1 200 OK
Date: Thu, 01 Jan 1970 00:00:00 GMT
Connection: close
Content-Type: text/html
Content-Length: ...

<html><body>...</body></html>
```

Rack takes an environment hash (containing the parsed method, URI, headers, body and returns a tuple of **status** (string or integer), **headers** (hash of key value pairs) and **body** (something that responds to **each**). For example:

```ruby
Proc.new do |env|
  [200, { "Content-Type" => "text/html" }, ['<html><body>...</body></html>']]
end
```

Rack packages a helpful DSL for constructing apps through rackup (**config.ru**) that makes loading applications easy:

```ruby
Rack::Builder.new do
  # ...
end
```

A detailed overview of the required and optional values that must be set on **env** can be found on the official [specification](http://www.rubydoc.info/github/rack/rack/file/SPEC). Additionally the HTTP 1.1 specification contains details on the request / response format.

# Putting it Together to Build a Launcher and Server

A Rack web server needs to bind and listen to a socket, accept a connection, parse the HTTP request, call into rack, generate the HTTP response, then close the connection. For the sample web server **Rhino::Launcher** handles binding, listening and closing the socket, **Rhino::Server** handles selecting and accepting a connection, and **Rhino::HTTP** handles parsing the HTTP request, sending it through Rack, then generating a response.

**lib/rhino.rb**

```ruby
require "rack"
require "slop"
require "socket"
require "time"
require "uri"

require "rhino/cli"
require "rhino/http"
require "rhino/launcher"
require "rhino/logger"
require "rhino/server"
require "rhino/version"

module Rhino
  def self.logger
    @logger ||= Rhino::Logger.new
  end
end
```

**lib/rhino/launcher.rb**

```ruby
module Rhino
  class Launcher

    def initialize(port, bind, reuseaddr, backlog, config)
      @port = port
      @bind = bind
      @reuseaddr = reuseaddr
      @backlog = backlog
      @config = config
    end

    def run
      Rhino.logger.log("Rhino")
      Rhino.logger.log("#{@bind}:#{@port}")

      begin
        socket = Socket.new(:INET, :STREAM)
        socket.setsockopt(:SOL_SOCKET, :SO_REUSEADDR, @reuseaddr)
        socket.bind(Addrinfo.tcp(@bind, @port))
        socket.listen(@backlog)

        server = Rhino::Server.new(application, [socket])
        server.run
      ensure
        socket.close
      end
    end

  private

    def application
      raw = File.read(@config)
      builder = <<~BUILDER
      Rack::Builder.new do
        #{raw}
      end
      BUILDER
      eval(builder, nil, @config)
    end

  end
end
```

**spec/rhino/launcher_spec.rb**

```ruby
require "spec_helper"

describe Rhino::Launcher do
  let(:port) { 80 }
  let(:bind) { "0.0.0.0" }
  let(:backlog) { 64 }
  let(:reuseaddr) { true }
  let(:config) { "./spec/support/config.ru" }
  let(:socket) { double(:socket) }
  let(:server) { double(:server) }

  describe "#run" do
    it "configures a socket and proxies to server" do
      launcher = Rhino::Launcher.new(port, bind, reuseaddr, backlog, config)

      expect(Rhino.logger).to receive(:log).with("Rhino")
      expect(Rhino.logger).to receive(:log).with("0.0.0.0:80")
      expect(Socket).to receive(:new).with(:INET, :STREAM) { socket }
      expect(socket).to receive(:bind)
      expect(socket).to receive(:setsockopt).with(:SOL_SOCKET, :SO_REUSEADDR, reuseaddr)
      expect(socket).to receive(:listen).with(backlog)
      expect(socket).to receive(:close)

      expect(Rhino::Server).to receive(:new) { server }
      expect(server).to receive(:run)

      launcher.run
    end
  end

end
```

**lib/rhino/server.rb**

```ruby
module Rhino
  class Server

    def initialize(application, sockets)
      @application = application
      @sockets = sockets
    end

    def run
      loop do
        begin
          monitor
        rescue Interrupt
          Rhino.logger.log("INTERRUPTED")
          return
        end
      end
    end

    def monitor
      selections, = IO.select(@sockets)
      io, = selections

      begin
        socket, = io.accept
        http = Rhino::HTTP::new(socket, @application)
        http.handle
      ensure
        socket.close
      end
    end

  end
end
```

**spec/rhino/server_spec.rb**

```ruby
require "spec_helper"

describe Rhino::Server do
  let(:server) { Rhino::Server.new(application, sockets) }
  let(:application) { double(:application) }
  let(:socket) { double(:socket) }
  let(:sockets) { [socket] }

  describe "#run" do
    it "handles interrupt" do
      expect(server).to receive(:monitor) { raise Interrupt.new }
      expect(Rhino.logger).to receive(:log).with("INTERRUPTED")
      server.run
    end
  end

  describe "#monitor" do
    it "selects then accepts and handles a connection" do
      io = double(:io)
      socket = double(:socket)
      http = double(:http)

      expect(Rhino::HTTP).to receive(:new).with(socket, application) { http }
      expect(http).to receive(:handle)

      expect(IO).to receive(:select).with(sockets) { io }
      expect(io).to receive(:accept) { socket }
      expect(socket).to receive(:close)

      server.monitor
    end
  end

end
```

**lib/rhino/http.rb**

```ruby
module Rhino
  class HTTP
    VERSION = "HTTP/1.1".freeze
    CRLF = "\r\n".freeze

    def initialize(socket, application)
      @socket = socket
      @application = application
    end

    def parse
      matches = /\A(?<method>\S+)\s+(?<uri>\S+)\s+(?<version>\S+)#{CRLF}\Z/.match(@socket.gets)
      uri = URI.parse(matches[:uri])

      env = {
        "rack.errors" => $stderr,
        "rack.version" => Rack::VERSION,
        "rack.url_scheme" => uri.scheme || "http",
        "REQUEST_METHOD" => matches[:method],
        "REQUEST_URI" => matches[:uri],
        "HTTP_VERSION" => matches[:version],
        "QUERY_STRING" => uri.query || "",
        "SERVER_PORT" => uri.port || 80,
        "SERVER_NAME" => uri.host || "localhost",
        "PATH_INFO" => uri.path || "",
        "SCRIPT_NAME" => "",
      }

      while matches = /\A(?<key>[^:]+):\s*(?<value>.+)#{CRLF}\Z/.match(hl = @socket.gets)
        case matches[:key]
        when Rack::CONTENT_TYPE then env["CONTENT_TYPE"] = matches[:value]
        when Rack::CONTENT_LENGTH then env["CONTENT_LENGTH"] = Integer(matches[:value])
        else env["HTTP_" + matches[:key].tr("-", "_").upcase] ||= matches[:value]
        end
      end

      env["rack.input"] = StringIO.new(@socket.read(env["CONTENT_LENGTH"] || 0))

      return env
    end

    def handle
      env = parse

      status, headers, body = @application.call(env)

      time = Time.now.httpdate

      @socket.write "#{VERSION} #{status} #{Rack::Utils::HTTP_STATUS_CODES.fetch(status) { 'UNKNOWN' }}#{CRLF}"
      @socket.write "Date: #{time}#{CRLF}"
      @socket.write "Connection: close#{CRLF}"

      headers.each do |key, value|
        @socket.write "#{key}: #{value}#{CRLF}"
      end

      @socket.write(CRLF)

      body.each do |chunk|
        @socket.write(chunk)
      end

      Rhino.logger.log("[#{time}] '#{env["REQUEST_METHOD"]} #{env["REQUEST_URI"]} #{env["HTTP_VERSION"]}' #{status}")
    end

  end
end
```

**spec/rhino/http_spec.rb**

```ruby
require "spec_helper"

describe Rhino::HTTP do
  let(:content) { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
  let(:socket) { double(:socket) }
  let(:application) { double(:application) }
  let(:http) { Rhino::HTTP.new(socket, application) }

  describe "#parse" do
    it "matches a valid request line and headers" do
      expect(socket).to receive(:gets) { "POST /search?query=sample HTTP/1.1#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Accept-Encoding: gzip#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Accept-Language: en#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Content-Type: text/html#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Content-Length: #{content.length}#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { Rhino::HTTP::CRLF }
      expect(socket).to receive(:read) { content }

      env = http.parse
      expect(env["HTTP_VERSION"]).to eql("HTTP/1.1")
      expect(env["REQUEST_URI"]).to eql("/search?query=sample")
      expect(env["REQUEST_METHOD"]).to eql("POST")
      expect(env["PATH_INFO"]).to eql("/search")
      expect(env["QUERY_STRING"]).to eql("query=sample")
      expect(env["SERVER_PORT"]).to eql(80)
      expect(env["SERVER_NAME"]).to eql("localhost")
      expect(env["CONTENT_TYPE"]).to eql("text/html")
      expect(env["CONTENT_LENGTH"]).to eql(content.length)
      expect(env["HTTP_ACCEPT_ENCODING"]).to eql("gzip")
      expect(env["HTTP_ACCEPT_LANGUAGE"]).to eql("en")
    end
  end

  describe "#handle" do
    it "handles the request with the application" do
      expect(Time).to receive(:now) { double(:time, httpdate: "Thu, 01 Jan 1970 00:00:00 GMT") }
      expect(application).to receive(:call) { [200, { "Content-Type" => "text/html" }, ["<html></html>"]] }

      expect(socket).to receive(:gets) { "GET / HTTP/1.1#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Accept-Encoding: gzip#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Accept-Language: en#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Content-Type: text/html#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Content-Length: #{content.length}#{Rhino::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { Rhino::HTTP::CRLF }
      expect(socket).to receive(:read) { content }

      expect(socket).to receive(:write).with("HTTP/1.1 200 OK#{Rhino::HTTP::CRLF}")
      expect(socket).to receive(:write).with("Date: Thu, 01 Jan 1970 00:00:00 GMT#{Rhino::HTTP::CRLF}")
      expect(socket).to receive(:write).with("Connection: close#{Rhino::HTTP::CRLF}")
      expect(socket).to receive(:write).with("Content-Type: text/html#{Rhino::HTTP::CRLF}")
      expect(socket).to receive(:write).with(Rhino::HTTP::CRLF)
      expect(socket).to receive(:write).with("<html></html>")

      expect(Rhino.logger).to receive(:log).with("[Thu, 01 Jan 1970 00:00:00 GMT] 'GET / HTTP/1.1' 200")

      http.handle
    end
  end

end
```

Once these changes are made the library can be tested by running:

```bash
bundle exec rspec spec
```

Furthermore the gem can be bundled and installed:

```bash
rake build
rake install
```

With the gem installed any Rack application can be served using it:

```bash
cd ~/...
rhino --port=3000 ./config.ru
```

# The Wrap Up

That is the base requirements for constructing a simple Rack web server. A slightly more robust version of the gem is available on [RubyGems](https://rubygems.org/gems/rhino) and [GitHub](https://github.com/ksylvest/rhino). Building a web server that can handle the rigor of the real world requires a few additional undertakings:

1. The article does not cover proper exception handling. What happens if a socket disconnects or is inaccessible? What happens if an invalid HTTP request is made? What happens if the rack application generates an exception? What happens if a client spams a socket?

2. The article also does not cover any concurrency (via threads or procs). Modern web frameworks use threads and procs to handle heavy traffic loads. An excellent pre-cursor [Working With Unix Processes by Jesse Storimer](http://www.jstorimer.com/products/working-with-unix-processes).

3. Finally the HTTP specification has a few quirks around parsing headers that aren't covered. Many sophisticated HTTP servers rely on [Ragel](http://www.colm.net/open-source/ragel/) instead of a simple set of regular expressions.
