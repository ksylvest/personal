---
date: "2024-06-09"
title: Using ChatGPT with Ruby
summary: A guide to using OpenAI’s ChatGPT with Ruby
tags:
  - openai
  - chatgpt
  - ruby
canonical_url: https://workflow.ing/blog/articles/using-chat-gpt-with-ruby
---

OpenAI offers official Node.js and Python client libraries for their API but does not currently package a gem for Rubyists looking to interact with their platform. A number of third party gems exist to simplify the integration, but integrating directly with OpenAI’s API is fairly straightforward thanks to their well documented with [curl](https://platform.openai.com/docs/api-reference/chat/create?lang=curl) examples. This article looks into the steps needed to make API calls using [HTTP.rb](https://github.com/httprb/http) for both regular and streamed completions.

## Requesting with HTTP.rb

To get started an API key is required. OpenAI offers the ability to [generate a an API key here](https://platform.openai.com/api-keys) in their dashboard. While Ruby offers basic HTTP functionality through `Net::HTTP`, using an HTTP client library greatly simplifies HTTP usage. While many options exist, [HTTP.rb](https://github.com/httprb/http) is a basic client that offers a terse and easy to understand API. It can be installed using `gem install http`. Once installed, it is time to make a ChatGPT API call:

```ruby
require 'http'

OPENAI_API_KEY = ENV.fetch('OPENAI_API_KEY', 'sk-...')

response = HTTP.auth("Bearer #{OPENAI_API_KEY}").post(
  "https://api.openai.com/v1/chat/completions",
  json: {
    model: 'gpt-4o',
    messages: [{
      role: "user",
      content: "Tell me a joke!",
    }],
  }
)

content = response.parse["choices"][0]["message"]["content"]
puts content # "Why don't skeletons fight each other? They don't have the guts!"
```

That’s it! We’ve made an API call to OpenAI’s ChatGPT. The HTTP.rb library automatically handles the parsing of the JSON response by calling `.parse`.

## Streaming with HTTP.rb

While our API works, it does not yet provide key visual flair of real-time typing. An important UI / UX integration that many LLM providers offer through their portals via streaming back responses. OpenAI is no exception. To stream back content via the API two changes are required:

1. Introduce the `stream: true` key to our request.
2. Handle the server sent event (SEE) streaming payload that HTTP.rb gives back.

To do this a new class is required that can properly handle the SEE paylods. It processes data in chunks using a buffer that it constantly flushes lines matching `data: ...\n\n`. Within the lines it parses JSON to grab the 'choices', then those are printed back to the user:

```ruby
require 'http'

OPENAI_API_KEY = ENV.fetch('OPENAI_API_KEY', 'sk-...')

class OpenAIEventStream
  LINE_REGEX = /data:\s*(?<data>.*)\n\n/

  def initialize
    @buffer = ""
  end

  # @yield [data] a parsed hash
  # @param [String] chunk
  def process!(chunk)
    @buffer << chunk

    while (line = @buffer.slice!(LINE_REGEX))
      match = LINE_REGEX.match(line)
      data = match[:data]
      break if data.eql?('[DONE]')
      yield JSON.parse(data)
    end
  end
end

response = HTTP.auth("Bearer #{OPENAI_API_KEY}").post(
  "https://api.openai.com/v1/chat/completions",
  json: {
    model: 'gpt-4o',
    messages: [{
      role: "user",
      content: "Tell me a joke!",
    }],
    stream: true,
  }
)

stream = OpenAIEventStream.new
response.body.each do |chunk|
  stream.process!(chunk) do |data|
    data["choices"].each do |choice|
      print(choice["delta"]["content"])
    end
  end
end
```

With this `OpenAIEventStream` class the data from OpenAI now prints in realtime! The text is streamed back to the user as it is generated via the LLM.

_This article originally appeared on [https://workflow.ing/blog/articles/using-chat-gpt-with-ruby](https://workflow.ing/blog/articles/using-chat-gpt-with-ruby)._
