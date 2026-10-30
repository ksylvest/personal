---
date: "2014-12-20"
title: Advanced Eager Loading in Rails
summary: How to load 'N' records per parent record efficiently in Ruby on Rails
tags:
  - ruby
  - rails
  - postgres
---

Rails includes a number of different methods (includes, preload, joins, etc.) that work exceptionally well for cases where all of an association must be loaded. These basic constructs can also be used to eager load partial sets of data efficiently. For example, suppose a simple Rails application includes three models: posts, users, and comments.

```bash
rails g model user name:string
rails g model post user:references title:string body:text
rails g model comment user:references post:references message:string
rake db:migrate
```

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
end
```

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
end
```

```ruby
# app/models/comment.rb
class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
end
```

```ruby
require 'faker'

users = Array.new(80) do
  User.create(name: Faker::Name.name)
end

posts = Array.new(80) do
  Post.create(user: users.sample, title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph)
end

128.times do
  users.each do |user|
    posts.each do |post|
      Comment.create(user: user, post: post, message: Faker::Lorem.sentence)
    end
  end
end
```

Now suppose that the example has a page that displays posts along some comments:

```bash
rails generate controller posts
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root to: 'posts#index'
end
```

```ruby
# app/controllers/posts_controller.rb
...
def index
  @posts = Post.all
end
...
```

```haml
- # app/views/posts/index.html.haml
- @posts.each do |post|
  = post.title
  = post.body
  = post.user.name
  - post.comments.each do |comment|
    = comment.message
    = comment.user.name
```

Loading the page results in hundreds of queries and about **2000ms**. For starters the gargantuan number of queries can be fixed by doing some eager loading:

```ruby
@posts = Post.includes(:user, comments: :user)
```

This reduces the number of queries to five and the load time to **500ms**. Our application probably doesn't need to display all comments but maybe just the a couple. This could be added by putting a _limit(n)_ call when looping over the comments, but doing so causes the eager loading to break. Alternatively the limit can be applied using slice (a Ruby instead of SQL call), but that still means loading all our comments into memory. Fortunately there is a third option:

```ruby
# app/models/comment.rb
class Comment < ActiveRecord::Base
  ...
  scope :recent, -> (count = 2) {
    subselect <<-SQL
    SELECT COUNT(*)
    FROM comments AS rcomments
    WHERE rcomments.post_id = comments.post_id AND rcomments.id > comments.id
    SQL
    where(":count > (#{subselect})").order(id: "DESC")
  }
end
```

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  ...
  has_many :recent_comments, -> { recent }, class_name: "Comment"
end
```

Swapping out _comments_ for _recent_comments_ in the view and controller results in a load time of **50ms**. That is a **40x** performance improvement from where the page started.

# Optimizations

While this optimization works great for tiny data sets the SQL query it generates is quadratic. When the posts start to have thousands of comments the runtime jumps to well over **2000ms**. Running an _explain analyze_ provides some insights that a simple index addition won't fix it. Fortunately PostgreSQL (and many other databases) support a much faster alternative method using "window functions":

```ruby
scope :recent, -> (count = 2) {
  rankings = "SELECT id, RANK() OVER(PARTITION BY post_id ORDER BY id DESC) rank FROM comments"

  joins("INNER JOIN (#{rankings}) rankings ON rankings.id = comments.id")
    .where("rankings.rank < :count", count: count.next)
    .order(id: "DESC")
}
```
