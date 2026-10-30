---
date: "2024-07-15"
title: OmniAI CLI
summary: OmniAI now ships with a built-in CLI, making it easier than ever to use OpenAI’s ChatGPT, Google’s Gemini, Anthropic’s Claude, or Mistral’s LeChat.
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
canonical_url: https://workflow.ing/blog/articles/omniai-cli
---

OmniAI now includes a built-in CLI to simplify testing various LLMs directly from the console.

## Installation

To use the OmniAI CLI, install the omniai gem along with any desired providers:

```bash
gem install omniai # required
gem install omniai-anthropic # optional
gem install omniai-google # optional
gem install omniai-mistral # optional
gem install omniai-openai # optional
```

## Configuration

For each LLM, ensure your shell has the appropriate environment variable for the API key. For example, for OpenAI make sure `ENV['OPENAI_API_KEY']` is present.

## Usage

Once your shell is configured with the appropriate environment variables, an interactive chat can be launched by running:

```bash
omniai chat --provider="anthropic"
```

This opens an interactive session where any prompts are sent to the LLM and the response is streamed back:

```
Type "exit" or "quit" to leave.

# Who built you?
I was built by Anthropic.

# What is the capital of France?
The capital of France is Paris.

# What is the most popular language in France other than French?
The most popular language in France other than French is Arabic.
```

To run a single prompt (useful when chaining together shell commands), use:

```bash
omniai chat --provider="openai" --model="gpt-4" --temperature=0.9 "Tell me a joke"
```

```
Why don't scientists trust atoms? Because they make up everything!
```

For more detailed documentation simply run `openai --help` or browse the [OmniAI CLI documentation](https://github.com/ksylvest/omniai#cli).

_This article originally appeared on [https://workflow.ing/blog/articles/omniai-cli](https://workflow.ing/blog/articles/omniai-cli)._
