---
date: "2017-10-27"
title: Transactions in Ruby on Rails and Atomic Bugs
summary: A few examples of when using a transaction in Ruby on Rails doesn't work as expected.
tags:
  - ruby
  - rails
  - transactions
---

Transactions in Ruby on Rails can be deceptively tricky to master. The following illustrates a few examples of when using simple transactions can go awry and inadvertently fail to provide atomicity.

# The Setup

This article explores a simple app composed of surveys and questions. Surveys require a name. Questions require some text. For the examples surveys have and belong to many questions.

```bash
rails new sample
cd sample
rails generate model survey name:string
rails generate model question text:string
rails generate migration CreateJoinTableSurveyQuestion survey question
rake db:create
rake db:migrate
```

**app/models/survey.rb**

```ruby
class Survey < ApplicationRecord
  validates :name, presence: true
  has_and_belongs_to_many :questions
  accepts_nested_attributes_for :questions
end
```

**app/models/question.rb**

```ruby
class Question < ApplicationRecord
  validates :text, presence: true
  has_and_belongs_to_many :surveys
end
```

# Example A

The helper methods provided by `has_many` or `has_and_belongs_to_many` associations exhibit interesting behaviour. Take the following snippet:

```ruby
survey = Survey.create(name: "Shapes")
question = Question.create(text: "How many sides does a nonagon have?")

survey.attributes = { name: "", question_ids: [question.id] }
survey.save
```

```sql
BEGIN
INSERT INTO "questions_surveys" ("survey_id", "question_id") VALUES (..., ...)
COMMIT
BEGIN
ROLLBACK
```

As seen assigning `question_ids=` (or `questions=`) through the attributes immediately executes insert statements that are committed outside any validations leading to the rollback.

Swapping `attributes=` and `save` for `update` provides the desired atomicity. Internally `update` wraps any changes with `with_transaction_returning_status` (a method that takes a block wrapped in a transaction that executes `COMMIT` if the block evaluates to a 'truthy' value or `ROLLBACK` if the block evaluates to a 'falsey' value).

```ruby
survey = Survey.create(name: "Shapes")
question = Question.create(text: "How many sides does a nonagon have?")

survey.update({ name: "", question_ids: [question.id] })
```

```sql
BEGIN
SELECT "questions".* FROM "questions" WHERE "questions"."id" IN (...)
SELECT "questions".* FROM "questions" INNER JOIN "questions_surveys" ON "questions"."id" = "questions_surveys"."question_id" WHERE "questions_surveys"."survey_id" = ...
INSERT INTO "questions_surveys" ("survey_id", "question_id") VALUES (..., ...)
ROLLBACK
```

**or**

```ruby
survey = Survey.create(name: "Shapes")
question = Question.create(text: "How many sides does a nonagon have?")

survey.with_transaction_returning_status do
  survey.attributes = { name: "", question_ids: [question.id] }
  survey.save
end
```

```sql
BEGIN
SELECT "questions".* FROM "questions" WHERE "questions"."id" IN (...)
SELECT "questions".* FROM "questions" INNER JOIN "questions_surveys" ON "questions"."id" = "questions_surveys"."question_id" WHERE "questions_surveys"."survey_id" = ...
INSERT INTO "questions_surveys" ("survey_id", "question_id") VALUES (..., ...)
ROLLBACK
```

# Example B

The transaction method might not work exactly as expected. Take the following snippet:

```ruby
survey = Survey.create(name: "Numbers")
question = Question.create(text: "What is Planck's constant?")

Survey.transaction do
  survey.update({ name: "", question_ids: [question.id] })
end
```

```sql
BEGIN
SELECT "questions".* FROM "questions" WHERE "questions"."id" = ...
SELECT "questions".* FROM "questions" INNER JOIN "questions_surveys" ON "questions"."id" = "questions_surveys"."question_id" WHERE "questions_surveys"."survey_id" = ...
INSERT INTO "questions_surveys" ("survey_id", "question_id") VALUES (..., ...)
COMMIT
```

Interestingly the fix demonstrated in the prior example is ineffective in this case. Nesting transactions by default only uses the parent transaction.

Raising a rollback exception or specifying the parent transaction to not be joinable ensures that partial changes are not saved. If the parent transaction is specified to be non-joinable save points are used internally as a mechanism to by most relational database systems.

```ruby
survey = Survey.create(name: "Numbers")
question = Question.create(text: "What is Planck's constant?")

Survey.transaction do
  unless survey.update({ name: "", question_ids: [question.id] })
    raise ActiveRecord::Rollback
  end
end
```

```sql
BEGIN
SELECT "questions".* FROM "questions" WHERE "questions"."id" = ...
SELECT "questions".* FROM "questions" INNER JOIN "questions_surveys" ON "questions"."id" = "questions_surveys"."question_id" WHERE "questions_surveys"."survey_id" = ...
INSERT INTO "questions_surveys" ("survey_id", "question_id") VALUES (..., ...)
ROLLBACK
```

**or**

```ruby
survey = Survey.create(name: "Numbers")
question = Question.create(text: "What is Planck's constant?")

Survey.transaction(joinable: false) do
  survey.update({ name: "", question_ids: [question.id] })
end
```

```sql
BEGIN
SAVEPOINT active_record_...
SELECT "questions".* FROM "questions" WHERE "questions"."id" = ...
SELECT "questions".* FROM "questions" INNER JOIN "questions_surveys" ON "questions"."id" = "questions_surveys"."question_id" WHERE "questions_surveys"."survey_id" = ...
INSERT INTO "questions_surveys" ("survey_id", "question_id") VALUES (..., ...)
ROLLBACK TO SAVEPOINT active_record_...
COMMIT
```

# Summary

Some rules can be extracted:

1. Avoid using the raw attributes API when dealing with assignable association and prefer using `update` / `create`.
2. While working with nesting either use exceptions to propagate rollbacks or use non joinable parent transactions.
