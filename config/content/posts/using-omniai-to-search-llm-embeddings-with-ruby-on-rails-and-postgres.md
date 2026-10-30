---
date: "2024-08-03"
title: Using OmniAI to Search LLM Embeddings with Ruby on Rails and Postgres
summary: OmniAI now supports the generation of embeddings for both Mistral and OpenAI. In conjunction with pgvector, this is an excellent option for indexing and searching data to pass through an LLM prompt within a Ruby on Rails application.
tags:
  - ruby
  - rails
  - openai
  - omniai
  - embeddings
canonical_url: https://workflow.ing/blog/articles/using-omniai-to-search-llm-embeddings-with-ruby-on-rails-and-postgres
---

OmniAI recently included support for generating embeddings using both [Mistral](https://docs.mistral.ai/capabilities/embeddings/) and [OpenAI](https://platform.openai.com/docs/guides/embeddings) APIs. Embeddings paired with a vector search tool can be used to filter text used in the consturction of LLM prompts. An example use might be filtering a list of products to those relevant to a question being asked. This article explains indexing and searching embeddings using OpenAI, Ruby on Rails, Postgres, and OmniAI.

## Setup

Start by creating a new Ruby on Rails application with Postgres:

```bash
rails new store --database=postgresql && cd store
```

With the basic app skeleton, [OmniAI](https://github.com/ksylvest/omniai) and [Neighbor](https://github.com/ankane/neighbor) can be installed. [OmniAI](https://github.com/ksylvest/omniai) provides the interface needed to send both completion (e.g. chat) and embedding requests to various LLM providers (e.g. Anthropic, OpenAI, Mistral, Google, etc) through a unified interface. [Neighbor](https://github.com/ankane/neighbor) provides the core `pgvector` constructs for searching via the approximate nearest neighbor search. Both can be added to the project using:

```bash
bundle add omniai omniai-openai neighbor
```

An initializer is required to configure OmniAI. This example uses OpenAI, but any LLM that supports generating embeddings works. This is optional if an `ENV['OPENAI_API_KEY']` is present in on the system, but the OpenAI `api_key` can be configured using:

```ruby
# config/initializers/omniai.rb
OmniAI::OpenAI.configure do |config|
  config.api_key = 'sk-...'
end
```

[pgvector](https://github.com/pgvector/pgvector) must also be installed if not already available. The [documentation](https://github.com/pgvector/pgvector#installation) includes platform specific instructions for Mac and Linux. Alternatively, if using the [Postgres.app](https://postgresapp.com/) on macOS this step may be skipped. Once `pgvector` is installed, it can be enabled in the app using:

```bash
rails generate migration enable_extension_vector
```

```ruby
# db/migrations/...enable_extension_vector.rb
class EnableExtensionVector < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'vector'
  end
end
```

## Embeddings

At this point the application has both [OmniAI](https://github.com/ksylvest/omniai) and [pgvector](https://github.com/pgvector/pgvector) installed and ready to use. The next step is to generate a table to store embeddings. This table maps an embedding (a list of floats) that can be used to compare the similarity of text against a polymorphic resource. The model can be generated using:

```bash
rails generate model embedding resource:references:polymorphic embedding:vector{3072}
```

```ruby
# db/migrations/...create_embeddings.rb
class CreateEmbeddings < ActiveRecord::Migration[7.1]
  def change
    create_table :embeddings do |t|
      t.references :resource, polymorphic: true, null: false
      t.vector :embedding, limit: 3072, null: false

      t.timestamps
    end
  end
end
```

```ruby
# app/models/embedding.rb
class Embedding < ApplicationRecord
  belongs_to :resource, polymorphic: true
  has_neighbors :embedding, dimensions: 3072
end
```

## Products

Now that the application includes a table for embeddings, any number of other models can be generated with an associated embedding. For this example a basic product with a name and summary is used. The model can be generated using:

```bash
rails generate model product name:string description:string
```

```ruby
# db/migrations/...create_products.rb
class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :summary, null: false

      t.timestamps
    end
  end
end
```

```ruby
class Product < ApplicationRecord
  has_one :embedding, inverse_of: :resource

  validates :name, presence: true
  validates :summary, presence: true

  def text
    "#{name}: #{summary}".gsub("\n", ' ')
  end

  scope :nearest_neighbors, ->(embedding, distance: :cosine) {
    joins(:embedding)
      .merge(Embedding.nearest_neighbors(:embedding, embedding, distance:))
      .reselect(%("products".*))
  }
end
```

## Prompting

With both products and embeddings, some test data is required. For this use case 5 products can be generated with embeddings using OmniAI:

```bash
bin/rails console
```

```ruby
Product.create!(name: 'Chair', summary: 'Made of solid oak.')
Product.create!(name: 'Table', summary: 'Made of solid maple.')
Product.create!(name: 'Toaster', summary: 'The perfect companion for a loaf of bread.')
Product.create!(name: 'Microwave', summary: 'Used to heat foods.')
Product.create!(name: 'Fridge', summary: 'Used to cool foods.')

openai = OmniAI::OpenAI::Client.new

Product.all.each do |product|
  response = openai.embed(product.text)
  embedding = product.build_embedding(embedding: response.embedding)
  embedding.save!
end
```

Lastly, an `ask` function can be defined that takes in a query and does the following:

1. Convert the query (text) into an embedding (vector).
2. Searches the products for the nearest 3 products.
3. Builds a prompt with a system / user message that contains the query and 3 products.
4. Prints the response to the console.

```bash
bin/rails console
```

```ruby
def ask(question)
  openai = OmniAI::OpenAI::Client.new
  response = openai.embed(question)
  products = Product.nearest_neighbors(response.embedding).first(3)

  openai.chat(stream: $stdout) do |prompt|
    prompt.system('You are a helpful assistant that answers a question (<question>...</question>) using the attached products (<products>...</products>).')
    prompt.user(<<~TEXT)
      <question>#{question}</question>
      <products>
        #{products.map { |product| "<product>#{product.text}</product>" }}
      </products>
    TEXT
  end
end
```

That's it! The `ask` method uses the generated embeddings to sort products by the similarity to the vectorized query. It return only the top 3 results to limit the size of the prompt:

```sql
SELECT "products".*
FROM "products"
INNER JOIN "embeddings" ON "embeddings"."resource_id" = "products"."id"
ORDER BY "embeddings"."embedding" <=> '[...]'
LIMIT 3
```

Let's try asking a few questions...

```ruby
ask('What materials are your tables and chairs made of?')

# The chairs are made of solid oak, and the tables are made of solid maple.
```

```ruby
ask('What products do you offer for heating or cooling food?')

# We offer the following products for heating or cooling food:
# 1. **Microwave:**
# 2. **Fridge:**
```

```ruby
ask('I have some stale bagels. Any product that can help?')

# For stale bagel, a toaster can be quite handy.
```

In each case nearest comparison is correctly finding appropriate products to pass through to the LLM to answer the provided question.

## Conclusion

`pgvector` offers a great solution for indexing data using LLM generated embeddings. This article didn't cover indexing, the choice of algorithm for usage within the similarity comparison, the choice of the model used to generate embeddings, or the dimensionality of the vectors generated. All merit further research for apps with performance considerations related to data size.

_This article originally appeared on [https://workflow.ing/blog/articles/using-omniai-to-search-llm-embeddings-with-ruby-on-rails-and-postgres](https://workflow.ing/blog/articles/using-omniai-to-search-llm-embeddings-with-ruby-on-rails-and-postgres)._
