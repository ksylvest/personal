---
date: "2024-09-04"
title: Using OmniAI to Convert PDFs to Markdown with LLMs
summary: A guide to converting a PDF into Markdown using OmniAI with OpenAI and MuPDF.
tags:
  - ruby
  - anthropic
  - google
  - mistral
  - openai
  - markdown
  - pdf
canonical_url: https://workflow.ing/blog/articles/using-omniai-to-convert-pdfs-to-markdown-with-llms
---

LLMs offer a great way to convert PDFs into Markdown. This can be especially useful for messy PDFs (scans, charts, diagrams, etc). Using [MuPDF](https://mupdf.com/) and [OmniAI](https://github.com/ksylvest/omniai) makes it simple.

## Step 1. Using MuPDF to Convert a PDF into PNGs

This guide walks through the process of converting a PDF page-by-page to handle the conversion. This requires splitting the PDF into multiple PNGs. [MuPDF](https://mupdf.com/) is a great solution for doing this. To use, the CLI MuPDF must be installed. On macOS it can be installed with:

```bash
brew install mupdf
```

Once the MuPDF CLI is installed a PDF can be converted using the following:

```bash
mutool draw -o "./demo-%d.png" -r 300 -F png ./demo.pdf
```

This command can be executed within a Ruby program using:

```ruby
require 'tmpdir'

# @param filename [String]
# @yield page
# @yieldparam file [File]
def pdf_to_pngs(filename:)
  Dir.mktmpdir do |dir|
    system("mutool", "draw", "-o", "#{dir}/%d.png", "-F", "png", filename)

    Dir.entries(dir).sort.each do |path|
      next unless path.match?(/^\d+.png$/)
      File.open("#{dir}/#{path}") do |file|
        yield(file)
      end
    end
  end
end
```

## Step 2. Using OmniAI to Convert a PNG into Markdown

With the PDF split into pages the next step is to use [OmniAI](https://github.com/ksylvest/omniai) to submit a prompt converting each PNG into Markdown. This guide uses OpenAI, but any of the following LLMs support converting PNGs to Markdown:

- [omniai-anthropic](https://github.com/ksylvest/omniai-anthropic)
- [omniai-google](https://github.com/ksylvest/omniai-google)
- [omniai-mistral](https://github.com/ksylvest/omniai-mistral)
- [omniai-openai](https://github.com/ksylvest/omniai-openai)

To install use the following:

```bash
gem install omniai # required
gem install omniai-anthropic # optional
gem install omniai-google # optional
gem install omniai-mistral # optional
gem install omniai-openai # optional
```

Then the conversion of PNG to Markdown can be done using:

```ruby
require 'omniai/openai'

# @param file [File]
# @param stream [IO]
def png_to_markdown(file:, stream: $stdout)
  client = OmniAI::OpenAI::Client.new
  completion = client.chat(stream:) do |prompt|
    prompt.system('You are an expert at converting files to markdown.')
    prompt.user do |message|
      message.text 'Convert the attached files to markdown.'
      message.file(file, "image/png")
    end
  end
end
```

## Summary

That’s it! The combined example is as follows:

```ruby
require 'tmpdir'
require 'omniai/openai'

# @param filename [String]
# @yield page
# @yieldparam file [File]
def pdf_to_pngs(filename:)
  Dir.mktmpdir do |dir|
    system("mutool", "draw", "-o", "#{dir}/%d.png", "-F", "png", filename)

    Dir.entries(dir).sort.each do |path|
      next unless path.match?(/^\d+.png$/)
      File.open("#{dir}/#{path}") do |file|
        yield(file)
      end
    end
  end
end

# @param file [File]
# @param stream [IO]
def png_to_markdown(file:, stream: $stdout)
  client = OmniAI::OpenAI::Client.new
  completion = client.chat(stream:) do |prompt|
    prompt.system('You are an expert at converting files to Markdown.')
    prompt.user do |message|
      message.text 'Convert the attached files to Markdown.'
      message.file(file, "image/png")
    end
  end
end

pdf_to_pngs(filename: "demo.pdf") { |file| png_to_markdown(file:) }
```

If everything worked a stream of markdown appears for each page of a PDF. To test try using the ["City of Vancouver Tourism Factsheet"](https://vancouver.ca/files/cov/other-sectors-tourism.PDF).

_This article originally appeared on [https://workflow.ing/blog/articles/using-omniai-to-convert-pdfs-to-markdown-with-llms](https://workflow.ing/blog/articles/using-omniai-to-convert-pdfs-to-markdown-with-llms)._
