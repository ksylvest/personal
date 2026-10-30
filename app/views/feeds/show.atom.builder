atom_feed do |feed|
  feed.title "Kevin Sylvestre"
  feed.updated @posts.map(&:date).max

  @posts.each do |post|
    url = post_url(segment: post.segment, slug: post.slug)
    feed.entry post, id: url, url:, published: post.date, updated: post.date do |entry|
      entry.title post.title
      entry.content post.summary, type: "html"
      entry.author do |author|
        author.name "Kevin Sylvestre"
      end
    end
  end
end
