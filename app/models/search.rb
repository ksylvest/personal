class Search
  include ActiveModel::Model

  attr_accessor :query

  def initialize(query)
    @query = query
  end

  # @return [Array<Post>, nil]
  def posts
    @posts ||= Post.search(query:) if present?
  end

  # @return [Array<Page>, nil]
  def pages
    @pages ||= Page.search(query:) if present?
  end

  delegate :present?, to: :@query
end
