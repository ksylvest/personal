xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Kevin Sylvestre"
    xml.description "A Ruby and iOS developer and designer."
    xml.link root_url

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.summary
        xml.pubDate post.date.rfc2822
        xml.link post_url(segment: post.segment, slug: post.slug)
        xml.guid post_url(segment: post.segment, slug: post.slug)
      end
    end
  end
end
