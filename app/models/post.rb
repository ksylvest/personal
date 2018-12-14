class Post < ApplicationRecord
  include Taggable
  include Approvable
  include Searchable
  include Attachable

  module Formats
    SEGMENT = '%Y-%m-%d'.freeze
  end

  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :summary, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: Validation::PERMALINK, scope: :segment }
  validates :segment, presence: true, format: { with: Validation::PERMALINK }
  validates :user, presence: true

  before_validation :defaults!

  scope :ordered, -> { order('id DESC') }
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
