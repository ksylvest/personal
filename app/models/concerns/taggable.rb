module Taggable
  extend ActiveSupport::Concern

  included do
    scope :tagged, ->(tags) { where('"tags" @> ARRAY[?]', tags) }

    scope :query, ->(filters) {
      tagged(filters[:tag]) if filters[:tag]
    }
  end

  def keywords
    tags.join(",")
  end

  def taggables
    tags.join(" ")
  end

  def taggables=(value)
    self.tags = value.split(/\W+/) if value
  end

end
