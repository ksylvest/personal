atom_feed do |feed|
  feed.title 'Kevin Sylvestre'
  feed.updated @posts.maximum(:updated_at) || @posts.maximum(:created_at)

  cache @posts do
    @posts.each do |post|
      cache post do
        feed.entry post, url: post_url(segment: post.segment, slug: post.slug) do |entry|
          entry.title post.title
          entry.content post.summary, type: 'html'
          if post.user
            entry.author do |author|
              author.name post.user.name
              author.email post.user.email
            end
          end
        end
      end
    end
  end
end
