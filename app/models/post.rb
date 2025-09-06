class Post < ApplicationRecord
  include Taggable
  include Approvable
  include Searchable
  include Attachable

  module Formats
    SEGMENT = "%Y-%m-%d".freeze
  end

  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :summary, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: Validation::PERMALINK }
  validates :segment, presence: true, format: { with: Validation::PERMALINK }

  before_validation :defaults!

  scope :canonical, -> { where(canonical_url: nil) }

  scope :ordered, -> { order(id: :desc) }
  scope :optimized, -> { includes(:user) }

  def date
    created_at || updated_at
  end

private

  def defaults!
    self.slug ||= title.parameterize if title.present?
    self.segment ||= Time.current.strftime(Formats::SEGMENT)
  end
end
