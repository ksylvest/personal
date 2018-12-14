class Search
  include ActiveModel::Model

  attr_accessor :query

  validates :query, presence: true

  def initialize(attributes = {})
    @query = attributes[:query] if attributes
  end

  def posts
    @posts ||= Post.search(@query) if present?
  end

  def pages
    @pages ||= Page.search(@query) if present?
  end

  def present?
    @query.present?
  end

end
