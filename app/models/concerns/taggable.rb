module Taggable
  extend ActiveSupport::Concern

  included do
    scope :tagged, ->(tag) { where('"tags" @> ARRAY[?]', tag) if tag }
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
