---
date: "2024-06-13"
title: Searching Files with ChatGPT Assistants
summary: Using a ChatGPT Assistant to Search Files (PDFs, DOCX, HTML and more) with Python
tags:
  - pdf
  - docx
  - files
  - chatgpt
  - openai
  - assistants
canonical_url: https://workflow.ing/blog/articles/searching-files-with-chat-gpt-assistants
---

OpenAI’s ChatGPT offers a handful of document focused capabilities when using the agent APIs. While these APIs are in beta, they offer a powerful method of searching through a [variety of files](https://platform.openai.com/docs/assistants/tools/file-search/supported-files) such as PDFs, HTML, DOCX, and more.

## Step 1: The Setup

To get started both Python and the latest version of the `openai` PIP package are required. The package can be installed using:

```bash
pip install openai
```

It is important to verify that the latest version of the `openai` package is installed. The agent APIs used in this article changed significantly between beta v1 and beta v2. At the time of publication, the latest version is `1.34.0`.

## Step 2: Configuring an Assistant

To get started with OpenAI’s file searching tools an agent is required. Agent configuration is a fairly straightforward process in which some general instructions are provided and tools are specified. An ENV variable called `OPENAI_API_KEY` must be present to configure an agent. Alternatively, the `api_key` can be passed as a string to the client (e.g. `OpenAI(api_key="sk-...")`). For this use case the `file_search` tool is given:

```python
from openai import OpenAI

client = OpenAI()

assistant = client.beta.assistants.create(
    name="Demo Assistant",
    instructions="You are an expert at searching PDFs. Use your knowledge base to answer questions.",
    model="gpt-4o",
    tools=[{"type": "file_search"}],
)
```

## Step 3: Preparing any Files

It is possible to attach a PDF using the files API. As a test, this article looks at the ["City of Vancouver Tourism Factsheet"](https://vancouver.ca/files/cov/other-sectors-tourism.PDF). To use this demo save that file locally as "vancouver.pdf".

```python
file = client.files.create(file=open("vancouver.pdf", "rb"), purpose="assistants")
```

## Step 4: Building a Thread

With the file ready it is time to prompt our agent using a thread. In this case the question is around the number of cruise ships in Vancouver for the 2017 / 2018 / 2019 years. If all goes well the data for that request exists on the 3rd page of the PDF in "FIGURE 5: CRUISE SHIP VISITS TO VANCOUVER". The data is embedded inside a chart.

```python
thread = client.beta.threads.create(messages=[{
    "role": "user",
    "content": "How many cruise ships visited Vancouver in 2017 / 2018 / 2019?",
    "attachments": [{ "file_id": file.id, "tools": [{ "type": "file_search" }] }]
}])
```

## Step 4: Running the Thread

Now that the thread is ready it is time to run and poll the thread:

```python
run = client.beta.threads.runs.create_and_poll(assistant_id=assistant.id, thread_id=thread.id)
messages = client.beta.threads.messages.list(thread_id=thread.id, run_id=run.id)
for message in messages:
    for content in message.content:
        if content.type == "text":
            print(content.text.value)
            print("\n")

            for annotation in content.text.annotations:
                print(annotation)
```

This run results in the expected counts along with annotations for the source:

```
The number of cruise ships that visited Vancouver were as follows:

- **2017**: 236 cruise ships
- **2018**: 243 cruise ships
- **2019**: 243 cruise ships

These numbers are detailed in the provided document which highlights Vancouver's tourism and economic impact【4:0†source】.

FileCitationAnnotation(file_citation=FileCitation(file_id='file-...'), start_index=282, end_index=294, text='【4:0†source】', type='file_citation')
```

## Step 5: The Cleanup

With our result if the agent / file / thread aren't needed anymore it is easy to delete them:

```python
client.files.delete(file.id)
client.beta.threads.delete(thread.id)
client.beta.assistants.delete(assistant.id)
```

## Summary

That’s it! The agent is built and able to process a prompt with files. The combined example looks like this:

```python
from openai import OpenAI

client = OpenAI()

assistant = client.beta.assistants.create(
    name="Demo Assistant",
    instructions="You are an expert at searching PDFs. Use your knowledge base to answer questions.",
    model="gpt-4o",
    tools=[{"type": "file_search"}],
)

file = client.files.create(file=open("vancouver.pdf", "rb"), purpose="assistants")

thread = client.beta.threads.create(messages=[{
    "role": "user",
    "content": "How many cruise ships visited Vancouver in 2017 / 2018 / 2019?",
    "attachments": [{ "file_id": file.id, "tools": [{ "type": "file_search" }] }]
}])

run = client.beta.threads.runs.create_and_poll(assistant_id=assistant.id, thread_id=thread.id)
messages = client.beta.threads.messages.list(thread_id=thread.id, run_id=run.id)

for message in messages:
    for content in message.content:
        if content.type == "text":
            print(content.text.value)
            print("\n")
            for annotation in content.text.annotations:
                print(annotation)

client.files.delete(file.id)
client.beta.threads.delete(thread.id)
client.beta.assistants.delete(assistant.id)
```

_This article originally appeared on [https://workflow.ing/blog/articles/searching-files-with-chat-gpt-assistants](https://workflow.ing/blog/articles/searching-files-with-chat-gpt-assistants)._
