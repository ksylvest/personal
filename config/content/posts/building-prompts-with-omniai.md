---
date: "2024-07-18"
title: Building Prompts with OmniAI
summary: OmniAI introduces the ability to generate complex prompts in Ruby with a prompt builder.
tags:
  - ruby
  - cli
  - openai
  - chatgpt
  - google
  - gemini
  - anthropic
  - claude
  - mistral
  - lechat
canonical_url: https://workflow.ing/blog/articles/building-prompts-with-omniai
---

The latest version of OmniAI introduces support for a dedicated prompt builder. This allows users to send in multimodal messages with files and customize user and system instructions.

## Installation

Installation of `omniai` works the same as any other gem:

```bash
gem install omniai # required
gem install omniai-anthropic # optional
gem install omniai-google # optional
gem install omniai-mistral # optional
gem install omniai-openai # optional
```

## Usage

OmniAI provides a basic method of building a completion using text:

```ruby
require 'omniai/anthropic'

client = OmniAI::Anthropic::Client.new
completion = client.chat('What is the best way to shave a yak?')
completion.choice.message.content # 'That seems rather pointless.'
```

To built more complex prompts, simply provide a block defining the user / system messages as needed:

```ruby
require 'omniai/openai'

client = OmniAI::OpenAI::Client.new
completion = client.chat do |prompt|
  prompt.system('You are an expert biologist with an expertise in animals.')
  prompt.user do |message|
    message.text 'What species are in the attached photos?'
    message.url('https://.../cat.jpeg', "image/jpeg")
    message.url('https://.../dog.jpeg', "image/jpeg")
    message.file('./hamster.jpeg', "image/jpeg")
  end
end
completion.choice.message.content # 'The photos are of a cat, a dog, and a hamster.'
```

Prompts defined using the above syntax are automatically compatible with Anthropic / Google / Mistral / OpenAI.

_This article originally appeared on [https://workflow.ing/blog/articles/building-prompts-with-omniai](https://workflow.ing/blog/articles/building-prompts-with-omniai)._
