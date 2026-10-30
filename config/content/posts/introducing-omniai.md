---
date: "2024-06-18"
title: Introducing OmniAI
summary: An LLM Agnostic Ruby Library for OpenAI’s ChatGPT, Google’s Gemini, Anthropic’s Claude Mistral’s LeChat, and More!
tags:
  - ruby
  - openai
  - chatgpt
  - google
  - gemini
  - anthropic
  - claude
  - mistral
  - lechat
canonical_url: https://workflow.ing/blog/articles/introducing-omniai
---

Exploring a variety of LLMs over the past few months has made it clear that they each have interesting strengths and weaknesses. OpenAI offers a solid foundation but may not always be the right solution based on either cost or quality. Sometimes Mistral’s LeChat or Anthropic’s Claude is the right choice. Sometimes the huge context window of Google’s Gemini is needed. Each LLM offers slightly different APIs and features, making it difficult to swap and compare results. Tools like [LangChain](https://github.com/langchain-ai/langchain) gave Python developers the ability to experiment with a consistent API. [OmniAI](https://github.com/ksylvest/omniai) aims to offer a similar benefit to Rubyists.

## Installation

Installation of `omniai` works the same as any other gem:

```bash
gem install omniai
```

The core library is split for each provider ([OpenAI](https://github.com/ksylvest/omniai-openai) / [Google](https://github.com/ksylvest/omniai-google) / [Mistral](https://github.com/ksylvest/omniai-mistral) / [Anthropic](https://github.com/ksylvest/omniai-anthropic)):

```bash
gem install omniai-anthropic
gem install omniai-google
gem install omniai-mistral
gem install omniai-openai
```

_For projects configured with `bundler`, include `omniai` in the Gemfile instead!_

## Configuration

Each OmniAI library is configured by simply setting an `ENV` variable with an `api_key`. Using OpenAI? Simply set `ENV['OPENAI_API_KEY']`. Need Google? Just make sure to set `ENV['GOOGLE_API_KEY']`. If required, libraries are also configurable using a block syntax. For example, with Mistral:

```ruby
require 'omniai/mistral'

OmniAI::Mistral.configure do |config|
  config.api_key = '...'
end
```

## Usage

OmniAI provides a consistent method for getting back a completion. For example, with OpenAI’s ChatGPT:

```ruby
require 'omniai/openai'

client = OmniAI::OpenAI::Client.new
completion = client.chat("What is the capital of Canada?")
completion.text # "The capital of Canada is Ottawa."
```

OmniAI also supports streaming for real-time responses. For example, with Google’s Gemini:

```ruby
require 'omniai/google'

client = OmniAI::Google::Client.new
stream = proc do |chunk|
  print(chunk.text) # 'A', 'penny', 'saved', ...
end
client.chat("What is a great proverb for saving?", stream:)
```

OmniAI also covers more complex integrations with combination of system and user messages, customized models, customized temperatures, and more. For example, with Anthropic’s Claude:

```ruby
require 'omniai/anthropic'

client = OmniAI::Anthropic::Client.new
completion = client.chat(model: OmniAI::Anthropic::Chat::Model::CLAUDE_OPUS, temperature: 0.9) do |prompt|
  prompt.system('Only respond in rhyme.')
  prompt.user('How do you eat an elephant?')
end
completion.text # 'To devour an elephant my friend. One bite at a time is the trend.'
```

For more examples, check the various projects on Github:

- [OmniAI](https://github.com/ksylvest/omniai)
- [OmniAI OpenAI](https://github.com/ksylvest/omniai-openai)
- [OmniAI Google](https://github.com/ksylvest/omniai-google)
- [OmniAI Mistral](https://github.com/ksylvest/omniai-mistral)
- [OmniAI Anthropic](https://github.com/ksylvest/omniai-anthropic)

_This article originally appeared on [https://workflow.ing/blog/articles/introducing-omniai](https://workflow.ing/blog/articles/introducing-omniai)._
