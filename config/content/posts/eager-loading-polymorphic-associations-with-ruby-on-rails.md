---
date: "2017-08-23"
title: Eager Loading Polymorphic Associations with Ruby on Rails
summary: A tutorial on eager loading polymorphic associations with Ruby on Rails avoiding "n-plus-one" queries.
tags:
  - ruby
  - rails
---

Efficiently eager loading polymorphic associations to avoid the 'n-plus-one' queries can be a challenge. Consider the following example:

```ruby
class Author < ApplicationRecord
  has_many :books
end
```

```ruby
class Director < ApplicationRecord
  has_many :films
end
```

```ruby
class Book < ApplicationRecord
  belongs_to :author
  has_many :likes, as: :resource
end
```

```ruby
class Film < ApplicationRecord
  belongs_to :director
  has_many :likes, as: :resource
end
```

```ruby
class Like < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :profile
end
```

```ruby
class Profile < ApplicationRecord
  has_many :likes
end
```

```ruby
nolan = Director.create!(name: "Nolan")
shakespeare = Author.create!(name: "Shakespeare")
memento = Film.create!(name: "Memento", director: nolan)
dunkirk = Film.create!(name: "Dunkirk", director: nolan)
macbeth = Book.create!(name: "Macbeth", author: shakespeare)
othello = Book.create!(name: "Othello", author: shakespeare)
john = Profile.create!(name: "John")
paul = Profile.create!(name: "Paul")
Like.create!(profile: john, resource: dunkirk)
Like.create!(profile: john, resource: macbeth)
Like.create!(profile: paul, resource: memento)
Like.create!(profile: paul, resource: othello)
```

Running these these produces an 'n-plus-one' query issue:

```ruby
Book.all.each do |book|
  puts book.name
  puts book.author.name
end
```

```sql
SELECT "books".* FROM "books"
SELECT "authors".* FROM "authors" WHERE "id" = 1
SELECT "authors".* FROM "authors" WHERE "id" = 2
...
```

```ruby
Film.all.each do |film|
  puts film.name
  puts film.director.name
end
```

```sql
SELECT "films".* FROM "films"
SELECT "films".* FROM "films" WHERE "id" = 1
SELECT "films".* FROM "films" WHERE "id" = 2
...
```

These are easily fixed by using `preload`:

```ruby
Book.preload(:author).each do |book|
  puts book.name
  puts book.author.name
end
```

```sql
SELECT "books".* FROM "books"
SELECT "authors".* FROM "authors" WHERE "authors"."id" IN (...)
```

```ruby
Film.preload(:director).each do |film|
  puts film.name
  puts film.director.name
end
```

```sql
SELECT "films".* FROM "films"
SELECT "directors".* FROM "directors" WHERE "directors"."id" IN (...)
```

Now consider accessing through a polymorphic association:

```ruby
Like.all.each do |like|
  puts like.resource.name
  puts case like.resource
  when Book like.resource.author.name
  when Film like.resource.director.name
  end
end
```

Attempting to eager load the authors or directors for the books or films is slightly more challenging. For this case `ActiveRecord::Association::Preloader` can be invoked manually:

```ruby
class Like::Preloader
  def self.preload(likes)
    preloader = ActiveRecord::Associations::Preloader.new
    preloader.preload(likes.select { |like| like.resource_type.eql?(Book.name) }, { resource: :author })
    preloader.preload(likes.select { |like| like.resource_type.eql?(Film.name) }, { resource: :director })
  end
end
```

```ruby
likes = Like.all
Like::Preloader.preload(likes)
likes.each do |like|
  puts like.resource.name
  puts case like.resource
  when Book like.resource.author.name
  when Film like.resource.director.name
  end
end
```

```sql
SELECT "likes".* FROM "likes"
SELECT "books".* FROM "books" WHERE "books"."id" IN (...)
SELECT "authors".* FROM "authors" WHERE "authors"."id" IN (...)
SELECT "films".* FROM "films" WHERE "films"."id" IN (...)
SELECT "directors".* FROM "directors" WHERE "directors"."id" IN (...)
```

Finally consider the following example:

```ruby
Profile.all.each do |like|
  puts profile.name
  profile.likes.each do |like|
    puts like.resource.name
    puts case like.resource
    when Book like.resource.author.name
    when Film like.resource.director.name
    end
  end
end
```

Attempting to eager load in this case can be solved using a combination of `preload` and the `ActiveRecord::Association::Preloader` manual invocation defined earlier:

```ruby
class Profile::Preloader
  def self.preload(profiles)
    LikePreloader.preload(profiles.map(&:likes).flatten)
  end
end
```

```ruby
profiles = Profile.preload(:likes)
Profile::Preloader.preload(profiles)
profiles.each do |like|
  puts profile.name
  profile.likes.each do |like|
    puts like.resource.name
    puts case like.resource
    when Book like.resource.author.name
    when Film like.resource.director.name
    end
  end
end
```

```sql
SELECT "profiles".* FROM "profiles"
SELECT "likes".* FROM "likes" WHERE "likes"."id" IN (...)
SELECT "books".* FROM "books" WHERE "books"."id" IN (...)
SELECT "authors".* FROM "authors" WHERE "authors"."id" IN (...)
SELECT "films".* FROM "films" WHERE "films"."id" IN (...)
SELECT "directors".* FROM "directors" WHERE "directors"."id" IN (...)
```
