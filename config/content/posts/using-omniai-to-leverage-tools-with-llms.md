---
date: "2024-08-16"
title: Using OmniAI to Leverage Tools with LLMs
summary: OmniAI now supports tools in LLM integrations using Anthropic, Google, Mistral, and OpenAI.
tags:
  - ruby
  - anthropic
  - google
  - mistral
  - openai
  - tools
canonical_url: https://workflow.ing/blog/articles/using-omniai-to-leverage-tools-with-llms
---

The predominant LLMs all support APIs to integrate tools. Tools offer a simple way to augment the generation of text using data specific to a domain the LLM is normally unaware of. The pattern for using tools within the APIs involves making multiple requests. The initial request provides the LLM with details about the available tools and a question that needs to be answered. The LLM responds with any calls needed to answer the question. A subsequent request is then submitted to the LLM with the additional data to generate the desired text. For example, suppose an app offers a function to find the weather for a location in either Celsius or Fahrenheit. The back and forth for such a tool might be as follows:

**Initial Request:** Submit a request with a set of tools and a question that needs answering:

_Request_: "What is the weather in London in Celsius and Paris in Fahrenheit?"

- tool: `weather(location: string, unit: 'celsius' | 'fahrenheit')`

_Response_:

- call#1: `weather("London", "celsius")`
- call#2: `weather("Paris", "fahrenheit")`

**Tool Usage:** Run the calls using the tools:

```
weather("London", "celsius") # 32°C
weather("Paris", "fahrenheit") # 72°F
```

**Subsequent Request:** Submit a request with the initial details as well as the tool call data:

_Request_: "What is the weather in London in Celsius and Paris in Fahrenheit?"

- tool: `function weather(location: string, unit: 'celsius' | 'fahrenheit')`
- call#1: `weather("London", "celsius") = "32°C"`
- call#2: `weather("Paris", "fahrenheit") = "72°F"`

_Response_: "The weather in London is 32°C and the weather in Paris is 72°F"

The APIs / process to make these requests differs slightly for each LLM provider. Thankfully, OmniAI now supports automating everything needed to make a tool-call using Anthropic, Google, Mistral, or OpenAI! This article documents the basic steps to accomplish the above using OmniAI.

## Setup

To get started [OmniAI](https://github.com/ksylvest/omniai) needs to be installed along with a provider:

```bash
gem install omniai # required
gem install omniai-anthropic # optional
gem install omniai-google # optional
gem install omniai-mistral # optional
gem install omniai-openai # optional
```

## Step 1: Initialize a Client

The APIs can be explored using `irb`. This example uses OpenAI and requires a client to be initialized:

```ruby
require 'omniai/openai'

client = OmniAI::OpenAI::Client.new(api_key: '...')
```

## Step 2: Define a Tool

The LLMs require documentation on your tool. Here's an example of defining a 'weather' tool:

```ruby
weather = OmniAI::Tool.new(
  proc { |location:, unit: 'Celsius'| "#{rand(20..50)}° #{unit} in #{location}" },
  name: 'weather',
  description: 'Lookup the weather in a location',
  parameters: OmniAI::Tool::Parameters.new(
    properties: {
      location: OmniAI::Tool::Property.string(description: 'e.g. Toronto'),
      unit: OmniAI::Tool::Property.string(enum: %w[Celsius Fahrenheit]),
    },
    required: %i[location]
  )
)
```

## Step 3: Prompting with Tools

The defined tool is then passed into a prompt for an inquiry:

```ruby
response = client.chat(tools: [weather]) do |prompt|
  prompt.user <<~TEXT
    What is the weather in "London" in Celsius and "Paris" in Fahrenheit?
    Also what are some ideas for activities in both cities given the weather?
  TEXT
end
puts response.text
```

## Summary

That’s it! The combined example looks like this:

```ruby
require 'omniai/openai'

client = OmniAI::OpenAI::Client.new(api_key: '...')

weather = OmniAI::Tool.new(
  proc { |location:, unit: 'celsius'| "#{rand(20..50)}° #{unit} in #{location}" },
  name: 'weather',
  description: 'Lookup the weather in a location',
  parameters: OmniAI::Tool::Parameters.new(
    properties: {
      location: OmniAI::Tool::Property.string(description: 'e.g. Toronto'),
      unit: OmniAI::Tool::Property.string(enum: %w[Celsius Fahrenheit]),
    },
    required: %i[location]
  )
)

response = client.chat(tools: [weather]) do |prompt|
  prompt.user <<~TEXT
    What is the weather in "London" in Celsius and "Paris" in Fahrenheit?
    Also what are some ideas for activities in both cities given the weather?
  TEXT
end
puts response.text
```

The LLMs is requesting a tool be called and using the result to generate a completion. If everything works as expected a response similar to the following is generated:

```
The weather in London is 35°C and in Paris is 34°F. Here are some activity suggestions based on the weather:

### London (35°C):
1. **Visit the Royal Parks**: Enjoy a leisurely day in one of London’s many beautiful parks like Hyde Park or Regent’s Park. Make sure to stay hydrated and wear sunscreen.
2. **Explore Museums**: Beat the heat by visiting indoor, air-conditioned attractions such as the British Museum or the Natural History Museum.
3. **River Cruise**: Take a relaxing boat cruise along the Thames River, where you can enjoy the sights with a cool breeze.

### Paris (34°F):
1. **Museums and Art Galleries**: Warm up by exploring iconic museums such as the Louvre or the Musee d'Orsay.
2. **Café Culture**: Sit inside a cozy Parisian café and enjoy a hot drink while people-watching.
3. **Shopping in Galeries Lafayette**: Spend some time shopping or window-shopping in the famous Galeries Lafayette, which is indoors and heated.

Stay safe and enjoy your time in these incredible cities!
```

## Conclusion

That's it! The LLM is responding with the required tool usage then generating a completion with it. These intermediary steps require no additional support. This example might be extended to support the following other examples:

- real-time data retrieval (e.g. "What is the current stock price for AAPL and MSFT?")
- querying a database (e.g. "What is the name of customer ID=5?")
- performing actions in your app (e.g. "Draft a message to Ringo letting them know they've got the job.")

_This article originally appeared on [https://workflow.ing/blog/articles/using-omniai-to-leverage-tools-with-llms](https://workflow.ing/blog/articles/using-omniai-to-leverage-tools-with-llms)._
